#!/bin/bash
# Scenario: Ruby comes from ghcr.io/devcontainers/features/ruby (rvm) and gem
# versions are pinned -> gems must land in that Ruby, at the pinned versions,
# without pulling in the distro Ruby fallback.
set -e

source dev-container-features-test-lib

check "ruby comes from the ruby feature (rvm)" bash -c "which ruby | grep -q rvm"
check "distro ruby fallback was not installed" bash -c "! dpkg -s ruby-full >/dev/null 2>&1"
check "ac-library-rb is pinned" bash -c "gem list ac-library-rb | grep -F '1.2.0'"
check "rbtree is pinned" bash -c "gem list rbtree | grep -F '0.4.7'"
check "numo-narray is pinned" bash -c "gem list numo-narray | grep -F '0.9.2.1'"
check "ac-library-rb works" ruby -e 'require "ac-library-rb/dsu"; include AcLibraryRb; d = DSU.new(3); d.merge(0, 1); exit(d.same?(0, 1) ? 0 : 1)'
check "rbtree works (native extension)" ruby -r rbtree -e 't = RBTree.new; t[1] = :a; exit(t[1] == :a ? 0 : 1)'

reportResults
