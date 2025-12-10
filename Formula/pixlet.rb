class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.49.6.tar.gz"
  sha256 "35c38e1a7210c9751071796ac6d753bc1abe3d5d1fd106dce098f27f1dff3352"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any,                 arm64_tahoe:  "81f21f5386f48616712666ebb6f07e4bc2ef6f6d708bc37af7d19751f243d8b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e9f8df89e17c9aa171e4c238b5aacdb454c63561ce196f3bc4c651778d1b782c"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "webp"

  def install
    cd "frontend" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

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
