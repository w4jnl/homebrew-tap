# nt for Mac: the notes repository in a window, nt's mark in the menu bar. Signed with a Developer
# ID and notarized; scripts/release.sh in w4jnl/nt writes this file at every tag.
cask "nt-app" do
  version "0.9.2"
  sha256 "dfd5d5a6812b45a7dd6df1f6a0a1dfe80482c465af02bc70a7f7af8fef604842"

  url "https://github.com/w4jnl/nt/releases/download/v#{version}/nt-#{version}.dmg"
  name "nt"
  desc "Plain markdown notes, synced by git, in live preview"
  homepage "https://github.com/w4jnl/nt"

  depends_on macos: :tahoe

  app "nt.app"

  zap trash: [
    "~/Library/Caches/nl.w4j.nt",
    "~/Library/HTTPStorages/nl.w4j.nt",
    "~/Library/Preferences/nl.w4j.nt.plist",
    "~/Library/Saved Application State/nl.w4j.nt.savedState",
    "~/Library/WebKit/nl.w4j.nt",
  ]

  caveats <<~EOS
    nt for Mac works on a notes repository nt set up. Without one:
      brew install w4jnl/tap/nt
      nt init ~/notes
  EOS
end
