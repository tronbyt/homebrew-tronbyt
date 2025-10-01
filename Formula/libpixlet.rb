class Libpixlet < Formula
  desc "Build apps for pixel-based displays"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "b46d5dab5125177fdc3b88e08306b06742a18d0c2fb65961337172aa508ad5fa"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any,                 arm64_tahoe:  "c201eea365586c16f59b1d553ce595ab613e800150e5519bc9193b88f7dc1964"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e1b971a288ef3e8c9af8010a23fd756d6d714d4c1c5d133cc8937de461a9eba0"
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
