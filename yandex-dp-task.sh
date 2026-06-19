#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title yandex tracker DOSTAVKAPIKO
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📋
# @raycast.aliases yd
# @raycast.argument1 { "type": "text", "placeholder": "DOSTAVKAPIKO", "optional": true }

DP_ID="$1"

if [ -n "$DP_ID" ]; then
  "$(dirname "$0")/lib/open-or-focus.sh" "https://tracker.yandex.ru/DOSTAVKAPIKO-${DP_ID}"
else
  "$(dirname "$0")/lib/open-or-focus.sh" "https://tracker.yandex.ru/agile/board/790"
fi
