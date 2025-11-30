class Libpixlet < Formula
  desc "Build apps for pixel-based displays"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.49.2.tar.gz"
  sha256 "f6e30793534bea638635112dbc01dbe65707f08cd88392720b4edcc307383e44"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any,                 arm64_tahoe:  "b2c4592d32268ff8917aa8bcb7e77ae602c421afd0353c69dc24c92d6fa6bca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bee4a3012e7f14ae8365eeda5a3b28dd0e83ee17d87416f1aac9e51a332216a2"
  end

  depends_on "go" => :build
  depends_on "webp"

  def install
    system "go", "generate", "./fonts"

    ldflags = %W[
      -s -w
      -X github.com/tronbyt/pixlet/runtime.Version=v#{version}
    ]

    tags = ["lib", "gzip_fonts"]

    system "go", "build",
      "-buildmode=c-shared",
      *std_go_args(ldflags: ldflags, tags: tags, output: shared_library("libpixlet")),
      "./library"

    # install dylib with version and symlink
    target = shared_library("libpixlet", version.to_s)
    lib.install shared_library("libpixlet") => target
    lib.install_symlink target => shared_library("libpixlet")
    lib.install_symlink target => shared_library("libpixlet", version.major.to_s)
    lib.install_symlink target => shared_library("libpixlet", version.major_minor.to_s)
    include.install "libpixlet.h"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libpixlet.h>

      int main() {
        init_cache();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test",
         "-I#{include}",
         "-L#{lib}",
         "-L#{Formula["webp"].opt_lib}",
         "-lwebp",
         "-lpixlet"
    system "./test"
  end
end
