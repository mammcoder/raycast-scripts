#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title deploy schedules
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📅

"$(dirname "$0")/lib/deploy-service.sh" couriers-schedules origin/develop
