#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title yandex tracker мои задачи
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ✅
# @raycast.aliases ym

"$(dirname "$0")/lib/open-or-focus.sh" "https://tracker.yandex.ru/dashboard/2938"
