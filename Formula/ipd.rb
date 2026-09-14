class Ipd < Formula
  desc "CLI tool to discover your public IP address"
  homepage "https://github.com/z0horizon/ip-discovery"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/z0horizon/ip-discovery/releases/download/v0.5.1/ipd-aarch64-apple-darwin.tar.xz"
      sha256 "5ba1d6a27d3d82791b8959e10d2b41dc2719e77b937a4fd6a74ad1780a12d416"
    end
    if Hardware::CPU.intel?
      url "https://github.com/z0horizon/ip-discovery/releases/download/v0.5.1/ipd-x86_64-apple-darwin.tar.xz"
      sha256 "c083f683f514af0ead95aee72908d2557937305f5f2073f40a1c13357042463a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/z0horizon/ip-discovery/releases/download/v0.5.1/ipd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "665678f8c18871744e4b79990a8b04af454bfd9adda8dfc87c05f40977215f19"
    end
    if Hardware::CPU.intel?
      url "https://github.com/z0horizon/ip-discovery/releases/download/v0.5.1/ipd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3b1679dfd87368e80c612b622558ff96f4b0f12b5b18992dd0db8da306c8122f"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ipd"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ipd"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ipd"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ipd"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
