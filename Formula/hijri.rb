class Hijri < Formula
  desc "A friendly cal-like command-line tool for Hijri (Islamic) dates (Umm al-Qura)"
  homepage "https://github.com/UtmostBoundary/hijri"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/UtmostBoundary/hijri/releases/download/v0.3.0/hijri-aarch64-apple-darwin.tar.xz"
      sha256 "4415b7f27c572e50419659f29aaaf208f0af6d434624731f61bf39de38bca458"
    end
    if Hardware::CPU.intel?
      url "https://github.com/UtmostBoundary/hijri/releases/download/v0.3.0/hijri-x86_64-apple-darwin.tar.xz"
      sha256 "bce20fe9c46e6ff32c06d72bb374d48443f36b643abf24894aa623699f92bb3f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/UtmostBoundary/hijri/releases/download/v0.3.0/hijri-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3f30ffe490fed2213babe02a7ecc7067ad4978bed8cce9c217318d7e4e0b9ec9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/UtmostBoundary/hijri/releases/download/v0.3.0/hijri-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "805964a2ae3f2729156cbc32ca94a930aea2754eeafea150e4bc726125cf3847"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "hijri" if OS.mac? && Hardware::CPU.arm?
    bin.install "hijri" if OS.mac? && Hardware::CPU.intel?
    bin.install "hijri" if OS.linux? && Hardware::CPU.arm?
    bin.install "hijri" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
