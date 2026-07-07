## What this installs

| Tool | Source | Default version |
| --- | --- | --- |
| `oj` ([online-judge-tools](https://github.com/online-judge-tools/oj)) | PyPI, into a dedicated venv under `/usr/local/share/online-judge-tools` | 11.5.1 |
| [online-judge-api-client](https://github.com/online-judge-tools/api-client) | PyPI (same venv) | 10.10.1 |
| `acc` ([atcoder-cli](https://github.com/Tatamo/atcoder-cli)) | npm (global) | 2.2.0 |

Note: this is **not** the PyPI package `atcoder-tools` — it bundles `oj` and `acc`.

## AtCoder memory-notation patch

AtCoder changed its memory-limit notation from KB/MB to KiB/MiB, which makes
unpatched `online-judge-api-client` fail with `AssertionError` when fetching
problem data. Until the upstream fix
([online-judge-tools/api-client#173](https://github.com/online-judge-tools/api-client/pull/173))
is merged and released, this feature applies that diff on top of the official
PyPI release (no third-party fork involved). Set `applyAtcoderMemoryPatch` to
`false` once the fix ships in the version you pin.

## Node.js

`acc` needs Node.js. If `npm` is already provided (e.g. by
`ghcr.io/devcontainers/features/node`, which this feature is ordered after),
it is used as-is; otherwise the distro's `nodejs`/`npm` packages are installed
as a fallback.

## Logging in to AtCoder

AtCoder sits behind a Cloudflare check, so `oj login` / `acc login` from inside
a container usually fails. Log in from your regular browser instead, copy the
`REVEL_SESSION` cookie, and write it into both tools' session stores
(`~/.local/share/online-judge-tools/cookie.jar` and
`~/.config/atcoder-cli-nodejs/session.json`). Authentication is per-machine
secret data — keep it out of the image (e.g. persist it in a named volume).

## OS support

Debian/Ubuntu (apt-based) images only.
