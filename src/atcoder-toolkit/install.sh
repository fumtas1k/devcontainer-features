#!/usr/bin/env bash
# atcoder-toolkit devcontainer feature
# Installs:
#   - oj  (online-judge-tools + online-judge-api-client) into a dedicated venv
#     under /usr/local/share/online-judge-tools, symlinked to /usr/local/bin/oj
#   - acc (atcoder-cli) via npm
#   - optionally applies the unmerged upstream fix
#     https://github.com/online-judge-tools/api-client/pull/173
#     (AtCoder memory notation changed KB/MB -> KiB/MiB)
set -euo pipefail

OJ_VERSION="${OJVERSION:-11.5.1}"
API_CLIENT_VERSION="${APICLIENTVERSION:-10.10.1}"
ACC_VERSION="${ACCVERSION:-2.2.0}"
APPLY_MEMORY_PATCH="${APPLYATCODERMEMORYPATCH:-true}"

FEATURE_DIR="$(cd "$(dirname "$0")" && pwd)"
VENV_DIR="/usr/local/share/online-judge-tools"

if [ "$(id -u)" -ne 0 ]; then
    echo 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.' >&2
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

apt_get_update() {
    if [ "$(find /var/lib/apt/lists/* -maxdepth 0 2>/dev/null | wc -l)" = "0" ]; then
        apt-get update -y
    fi
}

# Install apt packages only if the corresponding ones are missing
check_packages() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
    fi
}

if ! command -v apt-get >/dev/null 2>&1; then
    echo "(!) Unsupported distribution. This feature currently supports Debian/Ubuntu." >&2
    exit 1
fi

# pip requirement spec: pin unless "latest"
pip_spec() {
    local package="$1" version="$2"
    if [ "$version" = "latest" ]; then
        echo "$package"
    else
        echo "$package==$version"
    fi
}

# --- oj (online-judge-tools) -------------------------------------------------
check_packages python3 python3-venv ca-certificates

echo "Installing online-judge-tools ($OJ_VERSION) + online-judge-api-client ($API_CLIENT_VERSION) into $VENV_DIR ..."
python3 -m venv "$VENV_DIR"
"$VENV_DIR/bin/pip" install --no-cache-dir --upgrade pip
"$VENV_DIR/bin/pip" install --no-cache-dir \
    "$(pip_spec online-judge-tools "$OJ_VERSION")" \
    "$(pip_spec online-judge-api-client "$API_CLIENT_VERSION")"
ln -sf "$VENV_DIR/bin/oj" /usr/local/bin/oj

# --- AtCoder memory-notation patch (api-client PR #173) ----------------------
if [ "$APPLY_MEMORY_PATCH" = "true" ]; then
    site="$("$VENV_DIR/bin/python" -c 'import onlinejudge, os; print(os.path.dirname(os.path.dirname(onlinejudge.__file__)))')"
    if grep -q "KiB" "$site/onlinejudge/service/atcoder.py"; then
        echo "AtCoder memory-notation patch already applied (or fixed upstream); skipping."
    else
        check_packages patch
        patch -p1 -d "$site" < "$FEATURE_DIR/oj-atcoder-memory.patch"
        echo "Applied oj-atcoder-memory.patch to $site"
    fi
fi

# --- acc (atcoder-cli) -------------------------------------------------------
# Prefer node provided by ghcr.io/devcontainers/features/node (installsAfter
# guarantees ordering); fall back to the distro's nodejs/npm.
if ! command -v npm >/dev/null 2>&1; then
    echo "npm not found; installing distro nodejs/npm as a fallback." \
         "Consider adding ghcr.io/devcontainers/features/node to control the Node.js version."
    check_packages nodejs npm
fi

if [ "$ACC_VERSION" = "latest" ]; then
    acc_spec="atcoder-cli"
else
    acc_spec="atcoder-cli@$ACC_VERSION"
fi
echo "Installing $acc_spec ..."
npm install -g "$acc_spec"

echo "Done. oj: $(oj --version 2>/dev/null || true), acc: $(acc --version 2>/dev/null || true)"
