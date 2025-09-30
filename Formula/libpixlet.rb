class Libpixlet < Formula
  desc "Build apps for pixel-based displays"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "91dd5cdfa6647cb90ba6cdf99f6cfc6b8f73fcf4ae31212211ca590067c9c54b"
  license "Apache-2.0"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any,                 arm64_sequoia: "1bf85092335d51a9f10bff5bff6d0f55f141982b2e29cbfb03615d43dedf6333"
    sha256 cellar: :any,                 ventura:       "778e7b2faac751aa3bac3fab58cf7495a3379471c88a5c97f153abf80516b2ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "570562c51d65be9845a7e65e3dcdb6ccdacc2ed67ff01b11384d6e9af4750d36"
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
