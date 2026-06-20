class Hijri < Formula
  desc "A friendly cal-like command-line tool for Hijri (Islamic) dates (Umm al-Qura)"
  homepage "https://github.com/UtmostBoundary/hijri"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/UtmostBoundary/hijri/releases/download/v0.2.0/hijri-aarch64-apple-darwin.tar.xz"
      sha256 "69799edec04210d8a07ef7d099dabe45ab3cf083c299dea361c16ffea5b84a8a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/UtmostBoundary/hijri/releases/download/v0.2.0/hijri-x86_64-apple-darwin.tar.xz"
      sha256 "c88e085190b4341542c42491618cb9352e14e75ca1adb872633bea6bc5ed5f63"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/UtmostBoundary/hijri/releases/download/v0.2.0/hijri-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4bd00f6d4decf67d64574d755c2dd8e442bffd7d275031e41e6afd14a333da52"
    end
    if Hardware::CPU.intel?
      url "https://github.com/UtmostBoundary/hijri/releases/download/v0.2.0/hijri-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "453aa57fc45804f0b7e3091aaa70e2e897bd4189662bb0ea1e85efb31e7019a4"
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
