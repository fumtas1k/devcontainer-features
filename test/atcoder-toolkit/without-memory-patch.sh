#!/bin/bash
# Scenario: opt-outs disabled (applyAtcoderMemoryPatch=false,
# installSessionHelper=false) -> tools installed, extras NOT installed.
set -e

source dev-container-features-test-lib

check "oj is on PATH" oj --version
check "acc is on PATH" acc --version
check "memory patch is NOT applied" bash -c "! grep -q 'KiB' \"\$(/usr/local/share/online-judge-tools/bin/python -c 'import onlinejudge.service.atcoder as m; print(m.__file__)')\""
check "set-atcoder-session is NOT installed" bash -c "! command -v set-atcoder-session"

reportResults
