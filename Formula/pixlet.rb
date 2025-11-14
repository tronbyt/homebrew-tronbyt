class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.47.3.tar.gz"
  sha256 "e78480e9e1e802c9d4ab98d143b1bf2ce044d95f8d4b7d9988c061c845bae3aa"
  license "Apache-2.0"
  revision 1
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any,                 arm64_tahoe:  "bc0f03fb9f649ae5d6bf815aff841dd505f907b4eaf5b3dfd8b860e2a8024156"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "838bb4f1165caf4dfc4c11e1e91444b8551e1628864683534b030d3a4c1aea2d"
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
      -X github.com/tronbyt/pixlet/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "github.com/tronbyt/pixlet"
  end

  test do
    system "#{bin}/pixlet", "version"
  end
end
