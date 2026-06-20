class Hijri < Formula
  desc "A friendly cal-like command-line tool for Hijri (Islamic) dates (Umm al-Qura)"
  homepage "https://github.com/UtmostBoundary/hijri"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/UtmostBoundary/hijri/releases/download/v0.1.0/hijri-aarch64-apple-darwin.tar.xz"
      sha256 "751dcd6a3ab2e7143b19777670c9ca2afba3573b910d0d542b52c2df1808b707"
    end
    if Hardware::CPU.intel?
      url "https://github.com/UtmostBoundary/hijri/releases/download/v0.1.0/hijri-x86_64-apple-darwin.tar.xz"
      sha256 "c144dd8b5d96121f5cfdc5fe65f36fd87f7bd89fb7840c8095d82f622bfdba51"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/UtmostBoundary/hijri/releases/download/v0.1.0/hijri-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7d88f77c50cd22b55c2d0ff052fe885ef111e422af878c767a0dd6567174a300"
    end
    if Hardware::CPU.intel?
      url "https://github.com/UtmostBoundary/hijri/releases/download/v0.1.0/hijri-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4048a4087cd17a4a9fd12dc1d3241f90371899e4049bba8040dc6061e4a4c209"
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
