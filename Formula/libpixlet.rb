class Libpixlet < Formula
  desc "Build apps for pixel-based displays"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.49.3.tar.gz"
  sha256 "ccd4e1aa90bc29adce7254e02a470abe7e139e008bf2fbd0ab70059960f249c1"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any,                 arm64_tahoe:  "e87d9ab81db2966fc4a39d1973a78c87a703368abe399bba406776593bcc146a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4ced8c8f88dec3105aa6dc631e6676cc134fd8a7d3ba308afedd69c0a13b77e2"
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
