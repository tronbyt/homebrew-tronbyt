class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tidbyt/pixlet"
  version "0.46.0"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "5ed7be9bf3b8f7dbf3837b2c3ea6da09ee8ac12cfc67b050e8eeb4e174393429"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "aaf71ea0c4f556103bee65bf54e50dfdb7c9960c9f3068872bf0e2f818c7f1c2"
  end

  depends_on "webp"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/tronbyt/pixlet/releases/download/v0.46.0/pixlet_v0.46.0_darwin_arm64.tar.gz"
      sha256 "524e522841e32841f67de00448ab2d99424295e34dc463552252d83aa8b37558"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tronbyt/pixlet/releases/download/v0.46.0/pixlet_v0.46.0_darwin_amd64.tar.gz"
      sha256 "3731180cdb60100f6e94fd2fb2a2c539cf38467291c727e4374e1817e420439e"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/tronbyt/pixlet/releases/download/v0.46.0/pixlet_v0.46.0_linux_amd64.tar.gz"
      sha256 "e462d4b1812fb777287b42580ba2ad671095a2e76866c2074966c65803b042ce"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/tronbyt/pixlet/releases/download/v0.46.0/pixlet_v0.46.0_linux_arm64.tar.gz"
      sha256 "e43d60049b266090a7e5c844a3e91f5efdd328cfd3306ba3ed38234d2c7e8e11"
    end
  end

  def install
    bin.install "pixlet"
  end

  test do
    system "#{bin}/pixlet", "version"
  end
end
