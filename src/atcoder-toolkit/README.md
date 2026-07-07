
# AtCoder toolkit (online-judge-tools + atcoder-cli) (atcoder-toolkit)

Installs online-judge-tools (oj) and atcoder-cli (acc) for competitive programming on AtCoder. Optionally applies the unmerged upstream fix (online-judge-tools/api-client#173) for AtCoder's KB/MB -> KiB/MiB memory-notation change.

## Example Usage

```json
"features": {
    "ghcr.io/fumtas1k/devcontainer-features/atcoder-toolkit:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| ojVersion | online-judge-tools version to install from PyPI ('latest' for the newest release). | string | 11.5.1 |
| apiClientVersion | online-judge-api-client version to install from PyPI ('latest' for the newest release). | string | 10.10.1 |
| accVersion | atcoder-cli version to install from npm ('latest' for the newest release). | string | 2.2.0 |
| applyAtcoderMemoryPatch | Apply the unmerged fix from online-judge-tools/api-client#173 (AtCoder changed memory notation from KB/MB to KiB/MiB). Disable once the fix is merged upstream and included in the pinned apiClientVersion. | boolean | true |
| installSessionHelper | Install the 'set-atcoder-session' command, which writes a browser-copied REVEL_SESSION cookie into both oj and acc session stores (AtCoder's Cloudflare check breaks in-container 'oj login' / 'acc login'). | boolean | true |

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

## Logging in to AtCoder (`set-atcoder-session`)

AtCoder sits behind a Cloudflare check, so `oj login` / `acc login` from inside
a container usually fails. This feature therefore ships a helper command
(disable with `installSessionHelper: false`):

1. Log in to AtCoder in your regular browser (passing the Cloudflare check)
2. DevTools → Application/Storage → Cookies → `https://atcoder.jp` → copy the
   `REVEL_SESSION` value
3. In the container run `set-atcoder-session` and paste the value

It writes the cookie into both tools' session stores
(`~/.local/share/online-judge-tools/cookie.jar` and
`~/.config/atcoder-cli-nodejs/session.json`). Verify with
`oj login --check https://atcoder.jp/`. Authentication is per-machine secret
data — keep it out of the image (e.g. persist those paths in named volumes).

## OS support

Debian/Ubuntu (apt-based) images only.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/fumtas1k/devcontainer-features/blob/main/src/atcoder-toolkit/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
