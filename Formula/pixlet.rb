class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "14fd29c9cdbf4c81ff7756d5a3afc5b5ebb68ff487625cc9993e48ae5d11a726"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any,                 arm64_tahoe:  "9f1ff78b54a826f532df5958dfba55343095cd49a31cdd516c70180c456d12f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e80f478ff0389832015a3762d8171ac22bdcafd7fc7a638f95592ce4997abd3f"
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
