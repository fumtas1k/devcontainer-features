#!/bin/bash
# Default test: feature installed on the base image with default options
# (no ruby feature -> exercises the distro Ruby fallback; latest gem versions).
set -e

source dev-container-features-test-lib

check "ruby is on PATH" ruby --version
check "ac-library-rb works" ruby -e 'require "ac-library-rb/dsu"; include AcLibraryRb; d = DSU.new(3); d.merge(0, 1); exit(d.same?(0, 1) ? 0 : 1)'
check "rbtree works (native extension)" ruby -r rbtree -e 't = RBTree.new; t[1] = :a; exit(t[1] == :a ? 0 : 1)'
check "numo-narray works (native extension)" ruby -r numo/narray -e 'exit(Numo::Int64.zeros(3).size == 3 ? 0 : 1)'

reportResults
