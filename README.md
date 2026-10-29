# homebrew-tap

Homebrew formulae for [strayer](https://github.com/strayer)'s tools.

```sh
brew install strayer/tap/dock-badge-counter
```

| Formula | Source |
|---|---|
| `claude-code-statusline` | https://github.com/strayer/claude-code-statusline |
| `dock-badge-counter` | https://github.com/strayer/dock-badge-counter |
| `sketchybar` | https://github.com/strayer/SketchyBar (patched test build for [FelixKratz/SketchyBar#852](https://github.com/FelixKratz/SketchyBar/issues/852), pinned to a commit; temporary) |

Formula versions are bumped by Renovate (`url` + `sha256` from each project's release tags) and automerge once `brew audit` passes; this repo is not edited by hand except to add or fix formulae.

`claude-code-statusline` is the exception: it installs the project's attested release binaries per platform, which Renovate's Homebrew manager can't rewrite. To bump it, change the version in each `url` and take the `sha256` values from the release's `checksums.txt`.
