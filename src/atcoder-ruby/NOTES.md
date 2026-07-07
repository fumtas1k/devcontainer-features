## What this installs

Globally installed gems (default: `ac-library-rb`, `rbtree`, `numo-narray`),
so solutions run with plain `ruby main.rb` — no `bundle exec`, no Gemfile.
This matches how the AtCoder judge itself provides gems.

Pin versions with `name@version`:

```jsonc
"features": {
    "ghcr.io/devcontainers/features/ruby:1": { "version": "3.4.5" },
    "ghcr.io/fumtas1k/devcontainer-features/atcoder-ruby:1": {
        "gems": "ac-library-rb@1.2.0 rbtree@0.4.7 numo-narray@0.9.2.1 ruby-lsp"
    }
}
```

## Ruby itself

This feature installs gems only. Bring Ruby with
`ghcr.io/devcontainers/features/ruby` (this feature is ordered after it via
`installsAfter`) so you control the exact Ruby version. If no Ruby is present,
the distro's `ruby-full`/`ruby-dev` packages are installed as a fallback.

Native-extension gems (`rbtree`, `numo-narray`) need a C toolchain;
`build-essential` is installed automatically when missing.

## Combining with atcoder-toolkit

Pair with
[`atcoder-toolkit`](https://github.com/fumtas1k/devcontainer-features/tree/main/src/atcoder-toolkit)
(oj + acc, language-agnostic) for a complete AtCoder setup.

## OS support

Debian/Ubuntu (apt-based) images only.
