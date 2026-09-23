#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title deploy bonuses
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 💰

"$(dirname "$0")/lib/deploy-service.sh" couriers-bonuses origin/test-deploy
