#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title deploy delivery
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🚚

"$(dirname "$0")/lib/deploy-service.sh" delivery-api origin/test-deploy
