#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title jaeger test
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🔬
# @raycast.aliases jt
# @raycast.argument1 { "type": "text", "placeholder": "traceID (optional)", "optional": true }

TRACE_ID="$1"
HOST="jaeger-stage.svc.vkusvill.ru"

if [ -n "$TRACE_ID" ]; then
  "$(dirname "$0")/lib/open-or-focus.sh" "https://${HOST}/trace/${TRACE_ID}" "${HOST}/trace/${TRACE_ID}"
else
  "$(dirname "$0")/lib/open-or-focus.sh" "https://${HOST}/search" "${HOST}"
fi
