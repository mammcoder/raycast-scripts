#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title deploy rewards
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🎁

"$(dirname "$0")/lib/deploy-service.sh" courier-rewards-calculation origin/test-deploy
