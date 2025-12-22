class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.49.7.tar.gz"
  sha256 "ac5ae9507edbcd4bba7d652d4849fdc1dd1469d504e6b3514c0e74b50615a070"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any,                 arm64_tahoe:  "1245dfc0d3cb2214aa543640144526c27b36698682fd6d087eaae6300da36775"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4499853f33ee51675f037e60416c249f1632c0a66cdd4c25a7e70df65620537d"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "webp"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    cd "frontend" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    ldflags = %W[
      -s -w
      -X github.com/tronbyt/pixlet/runtime.Version=v#{version}
    ]

    tags = ["gzip_fonts"]

    system "go", "build", *std_go_args(ldflags:, tags:), "github.com/tronbyt/pixlet"

    generate_completions_from_executable(bin/"pixlet", "completion")
  end

  test do
    assert_match "Pixlet version:", shell_output("#{bin}/pixlet version")
  end
end
