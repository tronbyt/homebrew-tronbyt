class Libpixlet < Formula
  desc "Build apps for pixel-based displays"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "eadaaa3f3dacae46d6119afc36fea9a1a3613188ff2b61cba0c0f2dc01a7840c"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any,                 arm64_tahoe:  "f3e26aad85dd460d2e4caa129b5350b7f2ae20f59a39ee75805b6e2c4ec96c4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "90af38f00b1375e951a86ab984f8cf14d042d1fc9030a10030abb5574d530125"
  end

  depends_on "go" => :build
  depends_on "webp"

  def install
    ldflags = %W[
      -s -w
      -X tidbyt.dev/pixlet/cmd.Version=#{version}
    ]

    system "go", "build",
      "-tags", "lib",
      "-buildmode=c-shared",
      *std_go_args(ldflags: ldflags, output: shared_library("libpixlet")),
      "library/library.go"

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
