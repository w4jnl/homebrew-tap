# nt for Mac: the notes repository in a window, nt's mark in the menu bar. Signed with a Developer
# ID and notarized; scripts/release.sh in w4jnl/nt writes this file at every tag.
cask "nt-app" do
  version "0.9.5"
  sha256 "83b9f8a0c6d554f1c1a46886a8328bf0393d4f22b5dbb0556d0246e249cc2e9a"

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
