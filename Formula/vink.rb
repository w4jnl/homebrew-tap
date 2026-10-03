# vink builds from the release tarball; scripts/release.sh in w4jnl/vink keeps the url and
# sha256 current at every tag.
class Vink < Formula
  desc "Self-hosted heartbeat and uptime monitor"
  homepage "https://github.com/w4jnl/vink"
  url "https://github.com/w4jnl/vink/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "096b97868277d7a5695f0cc2ac86b64bb2a272e4936b71c00a0133d9f27ad691"
  license "MIT"
  head "https://github.com/w4jnl/vink.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/w4jnl/vink/internal/version.Version=#{version}"
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/vink"
    generate_completions_from_executable(bin/"vink", "completion")
  end

  def caveats
    <<~EOS
      Bootstrap a database, then start the server (:8080, vink.db and secret.key in the
      working directory; see `vink serve --print-config` for every setting):
        printf 'a-long-password\\n' | vink admin init --org homelab --user admin --password-stdin
        vink serve
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vink version")
  end
end
