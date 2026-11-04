# doma for Mac: the family's lists in a window. Signed with a Developer ID and notarized;
# scripts/release.sh in w4jnl/doma writes this file at every tag.
cask "doma" do
  version "0.2.0"
  sha256 "10ded79346580db4fa82c664ac55ef19cfffc290723fac7b4bcf1c5dbf7dfda4"

  url "https://github.com/w4jnl/doma/releases/download/v#{version}/doma-#{version}.dmg"
  name "doma"
  desc "Family shopping lists, synced through your own server"
  homepage "https://github.com/w4jnl/doma"

  depends_on macos: :tahoe

  app "doma.app"

  zap trash: "~/Library/Containers/nl.w4j.doma.mac"

  caveats <<~EOS
    doma for Mac joins your household with an invite from a phone that is already in it:
    Settings, Add a device. Where the lists live is your own server; see
    https://github.com/w4jnl/doma.
  EOS
end
