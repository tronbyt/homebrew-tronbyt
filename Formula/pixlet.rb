class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.49.2.tar.gz"
  sha256 "f6e30793534bea638635112dbc01dbe65707f08cd88392720b4edcc307383e44"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any,                 arm64_tahoe:  "1dbae1aac7cf0bcb2580980a4697baaab0dbad571994915516103e43d017a6ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b846e7f593509c59146c1ec80a8414a3f72ce4b911fa48a20dfaf527365b24df"
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
