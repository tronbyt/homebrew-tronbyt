class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.47.3.tar.gz"
  sha256 "e78480e9e1e802c9d4ab98d143b1bf2ce044d95f8d4b7d9988c061c845bae3aa"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any,                 arm64_tahoe:  "5dbc800d5c1d1bd297eed0feac06262a067d34ec17c0f662cd13855877aa0ab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7464cdd1402c594723cf3136505c81b39cecc6a9ac18b7b0396bd7cd517e3108"
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
      -X tidbyt.dev/pixlet/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "github.com/tronbyt/pixlet"
  end

  test do
    system "#{bin}/pixlet", "version"
  end
end
