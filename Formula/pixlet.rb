class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tidbyt/pixlet"
  version "0.45.0"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "9b5c64d390c84f404cb54b90f62e184f824c3767c83b4b9e27ab22cd8d155325"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f662b1db37053fe322774c96a36255d2f2ad58c98b2739274186fb1477a6e8d3"
  end

  depends_on "webp"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/tronbyt/pixlet/releases/download/v0.45.0/pixlet_v0.45.0_darwin_arm64.tar.gz"
      sha256 "5f140b2f9630557e2fa97042a0b8937728de25ba117407aba76d0be7fc7752b0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tronbyt/pixlet/releases/download/v0.45.0/pixlet_v0.45.0_darwin_amd64.tar.gz"
      sha256 "f4f65cfd4aa933568c4da6047a226e79c5eca0a73c99afd138bb1bc677ada88b"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/tronbyt/pixlet/releases/download/v0.45.0/pixlet_v0.45.0_linux_amd64.tar.gz"
      sha256 "2cfd511b4167652fd4e3f8a34f95bcb8199ccb8982fdf3447e1215d68eda9cc3"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/tronbyt/pixlet/releases/download/v0.45.0/pixlet_v0.45.0_linux_arm64.tar.gz"
      sha256 "2620e8785de927f0323c8a3fe838011b28e03523e5fb8524344f0fdf0063b856"
    end
  end

  def install
    bin.install "pixlet"
  end

  test do
    system "#{bin}/pixlet", "version"
  end
end
