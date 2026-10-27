# nt builds from the release tarball; scripts/release.sh in w4jnl/nt keeps the url and sha256
# current at every tag.
class Nt < Formula
  desc "Plain markdown notes, synced by git"
  homepage "https://github.com/w4jnl/nt"
  url "https://github.com/w4jnl/nt/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "4d3b314632880d27d93afc67281806bcbad478555ce1cdfe8d228f4b7c0a6601"
  license "MIT"
  head "https://github.com/w4jnl/nt.git", branch: "main"

  depends_on "go" => :build
  depends_on "fzf"
  depends_on "ripgrep"

  def install
    ldflags = "-s -w -X github.com/w4jnl/nt/internal/cli.Version=#{version}"
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/nt"
    generate_completions_from_executable(bin/"nt", "completion", shells: [:bash, :zsh])
  end

  def caveats
    <<~EOS
      Make a notes repository, or clone yours on a second machine:
        nt init ~/notes
        nt init --clone git@github.com:<you>/notes.git
      Then sync it in the background, add the nvim plugin and the agent hooks and skill, and check:
        nt install --sync --nvim --hooks --skill
        nt doctor
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nt version")
    ENV["NT_CONFIG"] = (testpath/"config.toml").to_s
    ENV["NT_STATE"] = (testpath/"state").to_s
    system bin/"nt", "init", testpath/"notes"
    system bin/"nt", "a", "brewed"
    assert_match "brewed", (testpath/"notes/daily").glob("*/*.md").first.read
  end
end
