class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.49.5.tar.gz"
  sha256 "3c32482e570923188dc935c794ea9a9dab688664adaa86711c6c0ad2a662edc6"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any,                 arm64_tahoe:  "3623735222fa9c14a22f95dad1b9c1a202b071a236a11d450bc9778228ab24f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d3a7a4329182242d24ba9a3e7363e9b1354fb48a7f6003902042e1a3bf9e90a5"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "webp"

  def install
    cd "frontend" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    system "go", "generate", "./fonts"

    ldflags = %W[
      -s -w
      -X github.com/tronbyt/pixlet/runtime.Version=v#{version}
    ]

    tags = ["gzip_fonts"]

    system "go", "build", *std_go_args(ldflags: ldflags, tags: tags), "github.com/tronbyt/pixlet"

    generate_completions_from_executable(bin/"pixlet", "completion")
  end

  test do
    system "#{bin}/pixlet", "version"
  end
end
