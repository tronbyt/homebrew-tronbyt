class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.47.2.tar.gz"
  sha256 "1ff56adea1b9e2a2323571dd06c4337282e2cac0f005de0eb8652fe42b47c720"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any,                 arm64_tahoe:  "b2b13448d7a422d3582dab0c5dc80c81c8b3d80d1d016490b6a7de2273555323"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9572d944d6d5a122d3c8c675386628f2f3f8206f32b2836eca24d18f28dc072b"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "webp"

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    ldflags = %W[
      -s -w
      -X tidbyt.dev/pixlet/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "tidbyt.dev/pixlet"
  end

  test do
    system "#{bin}/pixlet", "version"
  end
end
