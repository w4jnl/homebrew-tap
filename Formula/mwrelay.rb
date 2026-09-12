# mwrelay lives in a PRIVATE repo: the source arrives over git+ssh, so the
# installing machine's own SSH key is the auth — no tokens, no tarballs.
# using: :git is required (scp-style URLs are not auto-detected), and the
# tag + revision pin is the integrity check: Homebrew refuses the fetch if
# the tag does not resolve to exactly that commit.
class Mwrelay < Formula
  desc "Store-and-forward SMTP relay for MotiveWave fills, with menu bar P&L"
  homepage "https://github.com/w4jnl/mwrelay"
  url "git@github.com:w4jnl/mwrelay.git",
      using:    :git,
      tag:      "v0.3.0",
      revision: "9124db03daf3f0b720fe5922ad54b0bbe665d3ec" # scripts/release.sh keeps these two lines current

  depends_on "go" => :build
  depends_on :macos # the daemon targets launchd; the bar is Cocoa (fyne.io/systray)

  def install
    # Stamp like the repo Makefile: git-describe-style version (v-prefixed),
    # short commit, UTC date. The commit comes from the pinned revision —
    # the build sandbox blocks git from reading the user's global config,
    # so `git rev-parse` is not an option here.
    commit = stable.specs[:revision].to_s[0, 7]
    ldflags = %W[
      -X main.version=v#{version}
      -X main.commit=#{commit}
      -X main.date=#{time.iso8601}
    ]
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/mwrelay"
    # The menu bar companion is the module's only cgo package.
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(output: bin/"mwrelay-bar", ldflags: ldflags), "./cmd/mwrelay-bar"
  end

  def caveats
    <<~EOS
      mwrelay manages its own LaunchAgent (nl.w4j.mwrelay) — do NOT use
      `brew services`. First run writes ~/.config/mwrelay/config.toml:
        mwrelay start && mwrelay config edit
        mwrelay service install     # launchd: starts now, at login, after crashes
      After an upgrade, relaunch the daemon from the new binary:
        brew upgrade mwrelay && mwrelay restart
      System Settings > Login Items lists the agent as from an
      "unidentified developer" (not Developer-ID signed); it runs normally.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mwrelay version")
    assert_match version.to_s, shell_output("#{bin}/mwrelay-bar version")
  end
end
