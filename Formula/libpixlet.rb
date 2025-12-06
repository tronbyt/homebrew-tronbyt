class Libpixlet < Formula
  desc "Build apps for pixel-based displays"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.49.4.tar.gz"
  sha256 "8390697f8aaba96550934bd60c787f6af9546b6fb2f142ff724604cddb2be204"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any,                 arm64_tahoe:  "bd6dcb19d0d90ffa23168c550d42b2c381276a959e3bdd045958d75c76ef0c89"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d4f148fc239add1215cf01e0276e9b24204bcf3a1b67fbd975d5101c8c863bfa"
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
