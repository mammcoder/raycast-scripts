#!/bin/bash
# Запускает lib/deploy.sh для сервиса couriers в новом окне Terminal (окно остаётся открытым).
# Usage: deploy-service.sh <service> <git-ref>
#   service — имя джобы без префикса deploy-, оно же имя view в Jenkins
#   (job/couriers/job/deploy-<service>, job/couriers/view/<service>/job/deploy-<service>/)
set -euo pipefail

[ $# -eq 2 ] || { echo "usage: $0 <service> <git-ref>" >&2; exit 1; }

service="$1"
ref="$2"
jenkins_url="${JENKINS_URL:-https://jenkins.int.vkusvill.ru}"
lib_dir="$(cd "$(dirname "$0")" && pwd)"

job_path="job/couriers/job/deploy-${service}"
job_ui_url="${jenkins_url}/job/couriers/view/${service}/job/deploy-${service}/"

# JENKINS_LOGIN и JENKINS_TOKEN берутся из .zshrc интерактивной оболочки Terminal
cmd="$(printf 'echo %q; JENKINS_URL=%q JENKINS_JOB_PATH=%q JENKINS_JOB_UI_URL=%q %q ARG_ENV_NAME=test ARG_REF=%q ARG_NEED_RECREATE_ENV=false ARG_DEPLOY_OPTS= ARG_ENABLE_ROLLBACK=true' \
	"deploy ${service} (${ref})" \
	"$jenkins_url" "$job_path" "$job_ui_url" "${lib_dir}/deploy.sh" "$ref")"

osascript - "$cmd" <<'EOF'
on run argv
	tell application "Terminal"
		activate
		do script (item 1 of argv)
	end tell
end run
EOF
