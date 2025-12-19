class Libpixlet < Formula
  desc "Build apps for pixel-based displays"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.49.7.tar.gz"
  sha256 "ac5ae9507edbcd4bba7d652d4849fdc1dd1469d504e6b3514c0e74b50615a070"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any,                 arm64_tahoe:  "50b7cdb99f2dd3af9ee91ef20110a9a978fabb6647c32053973d627b0f5bab9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bd0346c01e1af82aaeac1d0ab622e44021d1f311641ca12af06fc0d7b2f9478c"
  end

  depends_on "go" => :build
  depends_on "webp"

  def install
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
