class Flok < Formula
  desc "Herdr-like agent sidebar for tmux"
  homepage "https://github.com/w4jnl/flok"
  url "https://github.com/w4jnl/flok/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "5857e71b5a7a6c18389326acafc9f5eb1758cff0d8ea26a35fc0fc4442dce11b"
  license "MIT"
  head "https://github.com/w4jnl/flok.git", branch: "main"

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ldflags = "-s -w -X github.com/w4jnl/flok/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/flok"
  end

  def caveats
    <<~EOS
      Wire the agent hooks and print the tmux.conf snippet:
        flok install
      Then start it from a plain terminal (not inside tmux):
        flok up
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flok version")
  end
end
