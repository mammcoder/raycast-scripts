#!/usr/bin/env bash
# Универсальный запуск Jenkins-пайплайна через REST (без jenkins-cli.jar)
set -euo pipefail

POLL_INTERVAL="${JENKINS_POLL_INTERVAL:-2}"
TIMEOUT_SEC="${JENKINS_TIMEOUT:-1800}"
# внутренний сертификат Jenkins часто самоподписанный; снять: JENKINS_CURL_OPTS=
CURL_OPTS="${JENKINS_CURL_OPTS:--k}"
CURL_TIMEOUT=(--connect-timeout 10 --max-time 30)
POLL_FAILS_MAX=5

notify_done() {
	local ok="$1"
	case "$(uname -s)" in
	Darwin)
		if [ "$ok" = 0 ]; then
			afplay /System/Library/Sounds/Glass.aiff >/dev/null 2>&1 &
		else
			afplay /System/Library/Sounds/Basso.aiff >/dev/null 2>&1 &
		fi
		;;
	*)
		if command -v powershell.exe >/dev/null 2>&1; then
			if [ "$ok" = 0 ]; then
				powershell.exe -NoProfile -Command "[console]::beep(880,400)" >/dev/null 2>&1 &
			else
				powershell.exe -NoProfile -Command "[console]::beep(220,600)" >/dev/null 2>&1 &
			fi
		else
			printf '\a'
		fi
		;;
	esac
}

die() {
	notify_done 1
	echo "error: $*" >&2
	exit 1
}

require_env() {
	local name="$1"
	[ -n "${!name:-}" ] || die "нужна переменная окружения $name"
}

json_field() {
	# потолок: компактный JSON, жадный .* берёт последнее вхождение ключа
	local json="$1" key="$2"
	# -E: в BSD sed (macOS) нет \| в BRE
	printf '%s' "$json" | sed -nE \
		-e "s/.*\"${key}\"[[:space:]]*:[[:space:]]*\"([^\"]*)\".*/\\1/p" \
		-e t \
		-e "s/.*\"${key}\"[[:space:]]*:[[:space:]]*(true|false|null|[0-9]+).*/\\1/p" \
		| head -n1
}

location_header() {
	printf '%s' "$1" | sed -n 's/^[Ll]ocation:[[:space:]]*//p' | tr -d '\r' | head -n1
}

http_status() {
	printf '%s' "$1" | sed -n 's/^HTTP\/[0-9.]*[[:space:]]*\([0-9][0-9][0-9]\).*/\1/p' | tail -n1
}

self_check() {
	local loc status crumb field cancelled number url building result

	loc="$(location_header $'HTTP/1.1 201 Created\r\nLocation: https://jenkins.example/queue/item/42/\r\n\r\n')"
	[ "$loc" = "https://jenkins.example/queue/item/42/" ] || die "self-check: Location"
	loc="$(location_header $'HTTP/1.1 201 Created\r\nLocation: /queue/item/42/\r\n\r\n')"
	[ "$loc" = "/queue/item/42/" ] || die "self-check: Location relative"

	status="$(http_status $'HTTP/1.1 201 Created\r\n')"
	[ "$status" = "201" ] || die "self-check: HTTP status"

	crumb="$(json_field '{"_class":"hudson.security.csrf.DefaultCrumbIssuer","crumb":"abc123","crumbRequestField":"Jenkins-Crumb"}' crumb)"
	[ "$crumb" = "abc123" ] || die "self-check: crumb"
	field="$(json_field '{"crumb":"abc123","crumbRequestField":"Jenkins-Crumb"}' crumbRequestField)"
	[ "$field" = "Jenkins-Crumb" ] || die "self-check: crumbRequestField"

	cancelled="$(json_field '{"cancelled":false,"executable":{"number":7,"url":"https://jenkins.example/job/x/7/"}}' cancelled)"
	[ "$cancelled" = "false" ] || die "self-check: cancelled"
	number="$(json_field '{"cancelled":false,"executable":{"number":7,"url":"https://jenkins.example/job/x/7/"}}' number)"
	[ "$number" = "7" ] || die "self-check: number (int)"
	url="$(json_field '{"cancelled":false,"executable":{"number":7,"url":"https://jenkins.example/job/x/7/"}}' url)"
	[ "$url" = "https://jenkins.example/job/x/7/" ] || die "self-check: url"

	building="$(json_field '{"building":true,"result":null}' building)"
	[ "$building" = "true" ] || die "self-check: building"
	result="$(json_field '{"building":false,"result":"SUCCESS"}' result)"
	[ "$result" = "SUCCESS" ] || die "self-check: result"
	result="$(json_field '{"building":false,"result":null}' result)"
	[ "$result" = "null" ] || die "self-check: result null"
	result="$(json_field $'{"result":"SUCCESS"}\n{"result":"FAILURE"}' result)"
	[ "$result" = "SUCCESS" ] || die "self-check: result first line"

	echo "self-check: ok"
	exit 0
}

if [ "${1:-}" = "--self-check" ]; then
	self_check
fi

require_env JENKINS_URL
require_env JENKINS_JOB_PATH
require_env JENKINS_LOGIN
require_env JENKINS_TOKEN

JENKINS_URL="${JENKINS_URL%/}"
JENKINS_JOB_PATH="${JENKINS_JOB_PATH#/}"
JENKINS_JOB_PATH="${JENKINS_JOB_PATH%/}"
JOB_API="${JENKINS_URL}/${JENKINS_JOB_PATH}"
auth=(-u "${JENKINS_LOGIN}:${JENKINS_TOKEN}")

jenkins_curl() {
	# --globoff: [number] в tree= это не glob curl
	# shellcheck disable=SC2086
	curl -sS --globoff $CURL_OPTS "${CURL_TIMEOUT[@]}" "${auth[@]}" "$@"
}

crumb_hdr=()
crumb_json="$(jenkins_curl "${JENKINS_URL}/crumbIssuer/api/json" || true)"
if [ -n "$crumb_json" ]; then
	crumb="$(json_field "$crumb_json" crumb)"
	crumb_field="$(json_field "$crumb_json" crumbRequestField)"
	if [ -n "$crumb" ] && [ -n "$crumb_field" ]; then
		crumb_hdr=(-H "${crumb_field}: ${crumb}")
	fi
fi

form=()
for arg in "$@"; do
	case "$arg" in
	*=*) form+=(--data-urlencode "$arg") ;;
	*) die "ожидал KEY=VALUE, получил: $arg" ;;
	esac
done

tmp_hdr="$(mktemp)"
tmp_body="$(mktemp)"
trap 'rm -f "$tmp_hdr" "$tmp_body"' EXIT INT TERM

http="$(jenkins_curl -D "$tmp_hdr" -o "$tmp_body" -w '%{http_code}' \
	-X POST "${crumb_hdr[@]}" \
	"${form[@]}" \
	"${JOB_API}/buildWithParameters" || true)"
headers="$(cat "$tmp_hdr")"
[ -z "$http" ] && http="$(http_status "$headers")"

if [ "$http" != "201" ] && [ "$http" != "200" ]; then
	hint=""
	case "$http" in
	401|403) hint=" проверь JENKINS_LOGIN и JENKINS_TOKEN" ;;
	esac
	head -n 10 "$tmp_body" >&2 || true
	die "не удалось запустить сборку (HTTP ${http:-?})${hint}"
fi

queue_url="$(location_header "$headers")"
[ -n "$queue_url" ] || die "Jenkins не вернул Location очереди (HTTP $http)"
case "$queue_url" in
/*) queue_url="${JENKINS_URL}${queue_url}" ;;
esac
queue_url="${queue_url%/}"

if [ -n "${JENKINS_JOB_UI_URL:-}" ]; then
	echo "job: ${JENKINS_JOB_UI_URL}"
fi

started_at="$(date +%s)"
elapsed() { echo $(( $(date +%s) - started_at )); }

poll_fails=0
build_number=""
while true; do
	if [ "$(elapsed)" -ge "$TIMEOUT_SEC" ]; then
		die "таймаут ожидания очереди (${TIMEOUT_SEC}s). queue: ${queue_url}/"
	fi
	qjson="$(jenkins_curl -f "${queue_url}/api/json?tree=executable[number],cancelled" || true)"
	if [ -z "$qjson" ]; then
		poll_fails=$((poll_fails + 1))
		[ "$poll_fails" -ge "$POLL_FAILS_MAX" ] && die "очередь недоступна (${POLL_FAILS_MAX} сбоев). ${queue_url}/"
		sleep "$POLL_INTERVAL"
		continue
	fi
	poll_fails=0
	if [ "$(json_field "$qjson" cancelled)" = "true" ]; then
		die "сборка снята из очереди"
	fi
	build_number="$(json_field "$qjson" number)"
	if [ -n "$build_number" ]; then
		break
	fi
	printf '\rв очереди... %ss' "$(elapsed)"
	sleep "$POLL_INTERVAL"
done
printf '\n'
build_url="${JOB_API}/${build_number}/"
echo "build: ${build_url}"

started_at="$(date +%s)"
poll_fails=0
result=""
while true; do
	if [ "$(elapsed)" -ge "$TIMEOUT_SEC" ]; then
		echo
		die "таймаут ожидания сборки (${TIMEOUT_SEC}s). ${build_url}"
	fi
	bjson="$(jenkins_curl -f "${build_url}api/json?tree=building,result" || true)"
	if [ -z "$bjson" ]; then
		poll_fails=$((poll_fails + 1))
		[ "$poll_fails" -ge "$POLL_FAILS_MAX" ] && die "сборка недоступна (${POLL_FAILS_MAX} сбоев). ${build_url}"
		sleep "$POLL_INTERVAL"
		continue
	fi
	poll_fails=0
	building="$(json_field "$bjson" building)"
	result="$(json_field "$bjson" result)"
	if [ "$building" = "false" ] && [ -n "$result" ] && [ "$result" != "null" ]; then
		break
	fi
	printf '\rвыполняется... %ss' "$(elapsed)"
	sleep "$POLL_INTERVAL"
done
printf '\n'

if [ "$result" = "SUCCESS" ]; then
	notify_done 0
	echo "SUCCESS ${build_url}"
	exit 0
fi
notify_done 1
echo "${result} ${build_url}"
exit 1
