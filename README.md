# Dev Container Features (fumtas1k)

個人用の [Dev Container Features](https://containers.dev/implementors/features/) 置き場。
[devcontainers/feature-starter](https://github.com/devcontainers/feature-starter) の構成に沿って
GitHub Actions（`devcontainers/action`）で GHCR に公開している。

## Features

### [`atcoder-toolkit`](./src/atcoder-toolkit)

AtCoder 用の CLI ツール一式（`oj` + `acc`）を導入する。
PyPI の `atcoder-tools` パッケージとは別物。

```jsonc
"features": {
    "ghcr.io/fumtas1k/devcontainer-features/atcoder-toolkit:1": {}
}
```

含まれるもの:

- `oj` ([online-judge-tools](https://github.com/online-judge-tools/oj)) — `/usr/local/share/online-judge-tools` の専用 venv に導入し `/usr/local/bin/oj` にリンク
- [online-judge-api-client](https://github.com/online-judge-tools/api-client) — AtCoder のメモリ表記変更 (KB/MB → KiB/MiB) 対応の未マージ修正 [api-client#173](https://github.com/online-judge-tools/api-client/pull/173) をパッチとして適用（オプションで無効化可）
- `acc` ([atcoder-cli](https://github.com/Tatamo/atcoder-cli)) — npm でグローバル導入（`npm` が無ければ distro の nodejs/npm にフォールバック）

オプション（バージョン固定・パッチ有無）は [src/atcoder-toolkit/README.md](./src/atcoder-toolkit/README.md) を参照。

## 開発

```sh
# テスト（Docker 必須）
npx @devcontainers/cli features test -f atcoder-toolkit -i mcr.microsoft.com/devcontainers/base:bookworm .

# 公開: main に push 後、GitHub Actions の
# "Release Dev Container Features & Generate Documentation" を手動実行
```

バージョンを上げるときは `src/atcoder-toolkit/devcontainer-feature.json` の `version` を更新してから release workflow を実行する。
