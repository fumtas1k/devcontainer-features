#!/bin/bash
# Scenario: node comes from ghcr.io/devcontainers/features/node (installsAfter
# ordering) -> acc must be installed with that npm, not the distro fallback.
set -e

source dev-container-features-test-lib

check "oj is on PATH" oj --version
check "acc is on PATH" bash -c "acc --version | grep -F '2.2.0'"
check "acc uses the node feature's npm (no distro fallback)" bash -c "! dpkg -s npm >/dev/null 2>&1"
check "AtCoder memory patch is applied" bash -c "grep -q 'KiB' \"\$(/usr/local/share/online-judge-tools/bin/python -c 'import onlinejudge.service.atcoder as m; print(m.__file__)')\""

reportResults
