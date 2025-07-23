class Libpixlet < Formula
  desc "Build apps for pixel-based displays"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "91dd5cdfa6647cb90ba6cdf99f6cfc6b8f73fcf4ae31212211ca590067c9c54b"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "c430bf18516a8cc6e62f3adf7618cf6852cce212a52cbf3b59c9f8e1e0aac873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53590f936b336f16bc506df6704e07f5bf31498c6fbd03a4cdbf1b42ceb42863"
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
