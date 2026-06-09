#!/bin/bash
# open-or-focus.sh <url> [match...]
#
# If a Safari tab's URL contains ALL match substrings, focus that tab.
# Otherwise open <url> in a new tab (or new window if none exists).
# If no match args are given, falls back to matching by <url> stripped of its query.

set -e

URL="$1"
shift || true

if [ -z "$URL" ]; then
  echo "usage: $0 <url> [match...]" >&2
  exit 1
fi

if [ "$#" -eq 0 ]; then
  STRIPPED="${URL%%\?*}"
  set -- "$STRIPPED"
fi

osascript - "$URL" "$@" <<'APPLESCRIPT'
on run argv
    if (count of argv) < 2 then
        error "open-or-focus: need <url> + at least one match"
    end if

    set targetURL to item 1 of argv
    set matchList to items 2 thru -1 of argv

    tell application "Safari"
        activate

        repeat with w in windows
            repeat with t in tabs of w
                try
                    set tabURL to URL of t
                    if tabURL is not missing value then
                        set ok to true
                        repeat with m in matchList
                            if tabURL does not contain (m as string) then
                                set ok to false
                                exit repeat
                            end if
                        end repeat
                        if ok then
                            set current tab of w to t
                            set index of w to 1
                            return
                        end if
                    end if
                end try
            end repeat
        end repeat

        if (count of windows) = 0 then
            make new document with properties {URL:targetURL}
        else
            tell window 1
                set newTab to make new tab with properties {URL:targetURL}
                set current tab to newTab
            end tell
        end if
    end tell
end run
APPLESCRIPT
