require "json"

class TronbytServer < Formula
  include Language::Python::Virtualenv

  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "aa8c9a5723edc79b78fd0dd94f50a1f5f0cdaa3a489fb623d072cc02e191be3a"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tronbyt/tronbyt"
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:  "71ff197be1c690cbb235d48f27ca41c5935f355480ab7a73238a739730921859"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "60b4a6cc25550ee90769086bf92e19921bcf6d7d36cd8e1210134ce0ea60136f"
  end

  depends_on "go" => :build
  depends_on "webp"

  def install
    commit = build.head? ? Utils.git_short_head : tap.user.to_s
    ldflags = %W[
      -s -w
      -X tronbyt-server/internal/version.Version=#{version}
      -X tronbyt-server/internal/version.Commit=#{commit}
      -X tronbyt-server/internal/version.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"tronbyt-server", ldflags: ldflags), "./cmd/server"

    unless (var/"tronbyt-server/.env").exist?
      (var/"tronbyt-server/.env").write <<~EOS
        # Add application configuration here.
        # For example:
        # LOG_LEVEL=INFO
      EOS
    end
  end

  def caveats
    <<~EOS
      Application configuration should be placed in:
        #{var}/tronbyt-server/.env
    EOS
  end

  service do
    run opt_bin/"tronbyt-server"
    keep_alive true
    log_path var/"log/tronbyt-server.log"
    error_log_path var/"log/tronbyt-server.log"
    working_dir var/"tronbyt-server"
  end

  test do
    port = free_port
    log_file = testpath/"tronbyt_server.log"
    (testpath/"data").mkpath
    File.open(log_file, "w") do |file|
      pid = spawn(
        {
          "PRODUCTION"   => "0",
          "TRONBYT_PORT" => port.to_s,
        },
        bin/"tronbyt-server",
        out: file,
        err: file,
      )
      sleep 5
      30.times do
        sleep 1
        break if log_file.read.include?("Listening on TCP")
      end
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
