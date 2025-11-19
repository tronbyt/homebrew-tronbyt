class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.48.1.tar.gz"
  sha256 "0622c57d695f524b540f265d21d5ee748c9552b3b6aa0222bcea3e3e979f982f"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any,                 arm64_tahoe:  "5bacac38517a1c9330a55b2728296f8866616af65622ab6e0ad771696f12b1b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a32eb2f26b0cecb66aa40fe3e647b972b3f5a14edbfc95b26be75c9f42877b7b"
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
