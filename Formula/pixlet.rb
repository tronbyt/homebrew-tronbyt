class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "eadaaa3f3dacae46d6119afc36fea9a1a3613188ff2b61cba0c0f2dc01a7840c"
  license "Apache-2.0"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "5ed7be9bf3b8f7dbf3837b2c3ea6da09ee8ac12cfc67b050e8eeb4e174393429"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "aaf71ea0c4f556103bee65bf54e50dfdb7c9960c9f3068872bf0e2f818c7f1c2"
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
