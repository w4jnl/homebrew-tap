# w4jnl/homebrew-tap

Homebrew tap for tools from [w4jnl](https://github.com/w4jnl).

```sh
brew tap w4jnl/tap
brew install flok        # herdr-like agent sidebar for tmux — https://github.com/w4jnl/flok
brew install mwrelay     # SMTP relay for MotiveWave fills — private repo: needs an SSH key with access
```

Formulae are bumped by `scripts/release.sh` in each project's repository.

Every push touching `Formula/` is installed from source, tested and audited on macOS and Linux
by the `formula` workflow — except mwrelay, whose private repo the runners cannot clone; it only
gets `brew style` here and is installed/tested on the dev machine before each bump.
