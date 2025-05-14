class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps."
  homepage "https://github.com/tidbyt/pixlet"
  version "0.42.1"

  depends_on "webp"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/tronbyt/pixlet/releases/download/v0.42.1/pixlet_v0.42.1_darwin_arm64.tar.gz"
      sha256 "d7e1c33fa4b877146c212fdbaec7aacc6973cf27fbc2683d37973cbfb84fd996"

      def install
        bin.install "pixlet"
      end
    end
    if Hardware::CPU.intel?
      url "https://github.com/tronbyt/pixlet/releases/download/v0.42.1/pixlet_v0.42.1_darwin_amd64.tar.gz"
      sha256 "06382d1017eb3a31fea0be705379938e2df36bb5c6bd94302186a0e9a4d4c5ee"

      def install
        bin.install "pixlet"
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/tronbyt/pixlet/releases/download/v0.42.1/pixlet_v0.42.1_linux_amd64.tar.gz"
      sha256 "cc5a92ea30836c62695e74759d41d7f8da32f0007e7afc99c1e1a92c2c8438b9"

      def install
        bin.install "pixlet"
      end
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/tronbyt/pixlet/releases/download/v0.42.1/pixlet_v0.42.1_linux_arm64.tar.gz"
      sha256 "17ad6fc74c25f62e044d0b021e143e4ae9beadf1d5c3db229951c233c58ad752"

      def install
        bin.install "pixlet"
      end
    end
  end

  test do
    system "#{bin}/pixlet", "--version"
  end
end
