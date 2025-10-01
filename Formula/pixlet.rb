class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tidbyt/pixlet"
  version "0.44.0"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "9b5c64d390c84f404cb54b90f62e184f824c3767c83b4b9e27ab22cd8d155325"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f662b1db37053fe322774c96a36255d2f2ad58c98b2739274186fb1477a6e8d3"
  end

  depends_on "webp"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/tronbyt/pixlet/releases/download/v0.44.0/pixlet_v0.44.0_darwin_arm64.tar.gz"
      sha256 "8dbbfaed1d9ea2e3e18abbe782e28cc6245a8939683344923e2901874fc2134f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tronbyt/pixlet/releases/download/v0.44.0/pixlet_v0.44.0_darwin_amd64.tar.gz"
      sha256 "02ff2ba9c1ec3b8aee0402f8cf19f871604a4e07647041e9f36e320d6103eaec"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/tronbyt/pixlet/releases/download/v0.44.0/pixlet_v0.44.0_linux_amd64.tar.gz"
      sha256 "bb8e55a3c4d7f8196bf5432480512f1195d9c80d3f9afd4207c961de205ea87c"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/tronbyt/pixlet/releases/download/v0.44.0/pixlet_v0.44.0_linux_arm64.tar.gz"
      sha256 "4d17da1b4bc3d949c1410dfc8a5f5703196fd04c9fe63a58d2fa07f04dc0179d"
    end
  end

  def install
    bin.install "pixlet"
  end

  test do
    system "#{bin}/pixlet", "version"
  end
end
