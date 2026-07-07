#!/bin/bash
# Scenario: applyAtcoderMemoryPatch=false -> tools installed, patch NOT applied.
set -e

source dev-container-features-test-lib

check "oj is on PATH" oj --version
check "acc is on PATH" acc --version
check "memory patch is NOT applied" bash -c "! grep -q 'KiB' \"\$(/usr/local/share/online-judge-tools/bin/python -c 'import onlinejudge.service.atcoder as m; print(m.__file__)')\""

reportResults
