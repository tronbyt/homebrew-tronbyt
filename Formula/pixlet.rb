class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tidbyt/pixlet"
  version "0.43.0"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd66396b6a14fe7d4772b974e84cf88b3dc184704a3274f81445e2ae439caa6d"
    sha256 cellar: :any_skip_relocation, ventura:       "e0ace01ea3cc4750a97c4791467011bc9468e6c8cbb26d3cba62fa6268de4da3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "314949c37022df6add9b34aec7797687bb8b05fe14920322ce1167d4a2144bd7"
  end

  depends_on "webp"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/tronbyt/pixlet/releases/download/v0.43.0/pixlet_v0.43.0_darwin_arm64.tar.gz"
      sha256 "cc060946cdf18db9338d28d710d44c73c55f503db210f538d32a23f9aae8080c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tronbyt/pixlet/releases/download/v0.43.0/pixlet_v0.43.0_darwin_amd64.tar.gz"
      sha256 "6f3c8df5938ca759fc4e0e04d0cc9998a6c4f6297b6241edfc8e3f6e6e100778"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/tronbyt/pixlet/releases/download/v0.43.0/pixlet_v0.43.0_linux_amd64.tar.gz"
      sha256 "76a68a2f34a17fde0fba065f512f14ac44079912755faf8910b90f6f1b5c2863"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/tronbyt/pixlet/releases/download/v0.43.0/pixlet_v0.43.0_linux_arm64.tar.gz"
      sha256 "20e043a4accedc68eb5cc10a82263c7deb4e7c5af57b1cdb1cc5b6a85a41bcd3"
    end
  end

  def install
    bin.install "pixlet"
  end

  test do
    system "#{bin}/pixlet", "version"
  end
end
