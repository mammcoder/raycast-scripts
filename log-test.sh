#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title log test
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📜
# @raycast.aliases lt

"$(dirname "$0")/lib/open-or-focus.sh" "https://grafana-vv.vkusvill.ru/explore?schemaVersion=1&panes=%7B%22trl%22%3A%7B%22datasource%22%3A%22ff1bpqfosxn9ca%22%2C%22queries%22%3A%5B%7B%22refId%22%3A%22A%22%2C%22expr%22%3A%22%22%2C%22queryType%22%3A%22range%22%2C%22datasource%22%3A%7B%22type%22%3A%22loki%22%2C%22uid%22%3A%22ff1bpqfosxn9ca%22%7D%7D%5D%2C%22range%22%3A%7B%22from%22%3A%22now-1h%22%2C%22to%22%3A%22now%22%7D%7D%7D&orgId=10" "ff1bpqfosxn9ca"
