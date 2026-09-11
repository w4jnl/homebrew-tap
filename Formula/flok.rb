class Flok < Formula
  desc "Herdr-like agent sidebar for tmux"
  homepage "https://github.com/w4jnl/flok"
  url "https://github.com/w4jnl/flok/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "3831c06a36387d1d7a94b53963646cb1b0da6970304449a076cadfd26f87efa3"
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
