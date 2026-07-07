#!/bin/bash
# Default test: feature installed on the base image with default options
# (no node feature -> exercises the distro nodejs/npm fallback).
set -e

source dev-container-features-test-lib

check "oj is on PATH" oj --version
check "oj version is pinned" bash -c "oj --version | grep -F '11.5.1'"
check "api-client version is pinned" bash -c "/usr/local/share/online-judge-tools/bin/pip show online-judge-api-client | grep -F 'Version: 10.10.1'"
check "AtCoder memory patch is applied" bash -c "grep -q 'KiB' \"\$(/usr/local/share/online-judge-tools/bin/python -c 'import onlinejudge.service.atcoder as m; print(m.__file__)')\""
check "acc is on PATH" bash -c "acc --version | grep -F '2.2.0'"

# set-atcoder-session: run with a dummy value and verify both session stores
check "set-atcoder-session writes oj cookie jar" bash -c "set-atcoder-session dummyvalue && grep -q 'REVEL_SESSION=dummyvalue' \"\$HOME/.local/share/online-judge-tools/cookie.jar\""
check "set-atcoder-session writes acc session.json" bash -c "grep -q 'REVEL_SESSION=dummyvalue' \"\$HOME/.config/atcoder-cli-nodejs/session.json\""

reportResults
