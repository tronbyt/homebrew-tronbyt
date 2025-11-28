class Libpixlet < Formula
  desc "Build apps for pixel-based displays"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "4de992daef09d0b2987c1734a0a5b2ec0ef5c9c51e37ce62bd65b9ec98439222"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any,                 arm64_tahoe:  "ee33110b432a5e2a005daa87733da2e7490d5465a26bfc42bf3b0770efd37eb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "92636334548cdd8e2bef230de0224d6468c5e04349e9f26a09d100802a1973fa"
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
