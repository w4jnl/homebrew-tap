class Flok < Formula
  desc "Herdr-like agent sidebar for tmux"
  homepage "https://github.com/w4jnl/flok"
  url "https://github.com/w4jnl/flok/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "e5cb6741f4b9fb652b8f61ee6435b0c2448e2df920418225070b88ea67812cc0"
  license "MIT"
  head "https://github.com/w4jnl/flok.git", branch: "main"

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ldflags = "-s -w -X github.com/w4jnl/flok/internal/cli.Version=#{version}"
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/flok"
    # The menu bar companion (since 0.2.0) needs cgo (fyne.io/systray) and the Cocoa frameworks.
    if OS.mac? && File.exist?("cmd/flok-bar/main.go")
      ENV["CGO_ENABLED"] = "1"
      system "go", "build", *std_go_args(output: bin/"flok-bar", ldflags: "#{ldflags} -X main.version=#{version}"),
             "./cmd/flok-bar"
    end
  end

  def caveats
    <<~EOS
      Wire the agent hooks, write a default config and print the tmux.conf snippet:
        flok install
      Then start it from a plain terminal (not inside tmux):
        flok up
      The macOS menu bar companion is opt-in: set `enabled = true` under [bar] in
      ~/.config/flok/config.toml.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flok version")
    if OS.mac? && (bin/"flok-bar").exist?
      assert_match version.to_s, shell_output("#{bin}/flok-bar version")
    end
  end
end
