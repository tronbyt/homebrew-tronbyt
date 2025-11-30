class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.49.2.tar.gz"
  sha256 "f6e30793534bea638635112dbc01dbe65707f08cd88392720b4edcc307383e44"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any,                 arm64_tahoe:  "99b7963fcbd6aa1f612ce480bae0ad8952736dc030a88f295e23e4f4e9792427"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f960a05b766b2773e140ab8773ad295d14bd308a8369fef1d803ea6f9ffcdc0a"
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
