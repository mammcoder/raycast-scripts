#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title kafka test
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🧪
# @raycast.aliases kt

"$(dirname "$0")/lib/open-or-focus.sh" "https://akhq-test.int.vkusvill.ru/ui/docker-kafka-server/topic" "akhq-test.int.vkusvill.ru"
