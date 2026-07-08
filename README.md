# Dev Container Features (fumtas1k)

個人用の [Dev Container Features](https://containers.dev/implementors/features/) 置き場。
[devcontainers/feature-starter](https://github.com/devcontainers/feature-starter) の構成に沿って
GitHub Actions（`devcontainers/action`）で GHCR に公開している。

このリポの案内（本 README）は日本語、公開される feature 単位のドキュメント
（`devcontainer-feature.json` の description と `NOTES.md`。release 時に
`src/<feature>/README.md` として自動生成される）はエコシステムの慣例に合わせて英語。

## Features

言語によらない AtCoder ツール（`atcoder-toolkit`）と、言語ごとの環境（`atcoder-ruby`）に
分かれている。組み合わせて使う:

```jsonc
"features": {
    // 言語によらない AtCoder ツール (oj + acc)
    "ghcr.io/fumtas1k/devcontainer-features/atcoder-toolkit:1": {},
    // Ruby 本体は公式 feature でバージョン固定
    "ghcr.io/devcontainers/features/ruby:1": { "version": "3.4.5" },
    // Ruby の競プロ用 gem をグローバルに焼き込み
    "ghcr.io/fumtas1k/devcontainer-features/atcoder-ruby:1": {
        "gems": "ac-library-rb@1.2.0 rbtree@0.4.7 numo-narray@0.9.2.1 ruby-lsp"
    }
}
```

### [`atcoder-toolkit`](./src/atcoder-toolkit)

[![GHCR](https://img.shields.io/badge/ghcr.io-atcoder--toolkit-blue?logo=github)](https://github.com/users/fumtas1k/packages/container/package/devcontainer-features%2Fatcoder-toolkit)

AtCoder 用の CLI ツール一式（`oj` + `acc`）。言語非依存。
PyPI の `atcoder-tools` パッケージとは別物。

- `oj` ([online-judge-tools](https://github.com/online-judge-tools/oj)) — `/usr/local/share/online-judge-tools` の専用 venv に導入し `/usr/local/bin/oj` にリンク
- [online-judge-api-client](https://github.com/online-judge-tools/api-client) — AtCoder のメモリ表記変更 (KB/MB → KiB/MiB) 対応の未マージ修正 [api-client#173](https://github.com/online-judge-tools/api-client/pull/173) をパッチとして適用（オプションで無効化可）
- `acc` ([atcoder-cli](https://github.com/Tatamo/atcoder-cli)) — npm でグローバル導入（`npm` が無ければ distro の nodejs/npm にフォールバック）
- `set-atcoder-session` コマンド — ブラウザで取得した `REVEL_SESSION` Cookie を oj / acc 両方に書き込むログインヘルパー（AtCoder の Cloudflare チェックでコンテナ内 `oj login` / `acc login` が通らない対策。オプションで無効化可）

オプション（バージョン固定・パッチ有無）は [src/atcoder-toolkit/README.md](./src/atcoder-toolkit/README.md) を参照。

### [`atcoder-ruby`](./src/atcoder-ruby)

[![GHCR](https://img.shields.io/badge/ghcr.io-atcoder--ruby-blue?logo=github)](https://github.com/users/fumtas1k/packages/container/package/devcontainer-features%2Fatcoder-ruby)

Ruby の競プロ環境。gem（既定: `ac-library-rb` `rbtree` `numo-narray`）を
**グローバルにインストール**し、`ruby main.rb` だけで解答を実行できるようにする
（AtCoder のジャッジ環境と同じく Bundler 不要）。`name@version` でピン留め可。

Ruby 本体は公式 ruby feature に任せる（この feature はその後に実行される）。
無ければ distro の Ruby にフォールバック。詳細は
[src/atcoder-ruby/README.md](./src/atcoder-ruby/README.md) を参照。

## 開発

```sh
# テスト（Docker 必須）。-f で feature を指定
npx @devcontainers/cli features test -f atcoder-toolkit -i mcr.microsoft.com/devcontainers/base:bookworm .
npx @devcontainers/cli features test -f atcoder-ruby -i mcr.microsoft.com/devcontainers/base:bookworm .

# 公開: main に push 後、GitHub Actions の
# "Release Dev Container Features & Generate Documentation" を手動実行
```

バージョンを上げるときは `src/<feature>/devcontainer-feature.json` の `version` を更新してから release workflow を実行する。
