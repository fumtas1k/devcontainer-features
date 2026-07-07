#!/usr/bin/env bash
# atcoder-ruby devcontainer feature
# Installs competitive-programming gems globally so solutions run with plain
# `ruby main.rb` (no Bundler), matching the AtCoder judge environment.
#
# Ruby itself is expected from ghcr.io/devcontainers/features/ruby
# (installsAfter guarantees ordering); falls back to the distro Ruby.
set -euo pipefail

GEMS="${GEMS:-ac-library-rb rbtree numo-narray}"

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

# Ruby: prefer one already provided (e.g. the ruby feature via rvm);
# fall back to the distro Ruby (incl. headers for native extensions).
if ! command -v gem >/dev/null 2>&1; then
    echo "gem not found; installing distro Ruby as a fallback." \
         "Consider adding ghcr.io/devcontainers/features/ruby to control the Ruby version."
    check_packages ruby-full ruby-dev
fi

# rbtree / numo-narray build native extensions -> need a C toolchain.
if ! command -v gcc >/dev/null 2>&1 || ! command -v make >/dev/null 2>&1; then
    check_packages build-essential
fi

for spec in $GEMS; do
    name="${spec%%@*}"
    if [ "$spec" != "$name" ]; then
        version="${spec#*@}"
        echo "Installing gem $name ($version) ..."
        gem install --no-document "$name" -v "$version"
    else
        echo "Installing gem $name (latest) ..."
        gem install --no-document "$name"
    fi
done

echo "Done. Installed gems:"
gem list | grep -E "^($(echo "$GEMS" | tr ' ' '\n' | sed 's/@.*//' | paste -sd '|' -)) " || true
