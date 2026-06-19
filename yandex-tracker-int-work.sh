#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title yandex tracker внутренние работы
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ⏰
# @raycast.aliases yi

"$(dirname "$0")/lib/open-or-focus.sh" "https://tracker.yandex.ru/dashboard/5040"
