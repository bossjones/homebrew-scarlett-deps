class LibvaUtils < Formula
  desc 'Libva-utils is a collection of tests for VA-API (VIdeo Acceleration API)'
  homepage 'https://01.org/linuxmedia'
  url 'https://github.com/01org/libva-utils/releases/download/2.0.0/libva-utils-2.0.0.tar.bz2'
  sha256 'a921df31311d8f49d2e392a5fc2a068d79f89aeb588309fbff24365310dbc5f6'

  head do
    url 'https://github.com/01org/libva-utils.git'
  end

  depends_on 'bossjones/scarlett-deps/libva2'

  def install
    system './configure', '--disable-debug',
           '--disable-dependency-tracking',
           '--disable-silent-rules',
           "--prefix=#{prefix}"
    system 'make', 'install'
  end

  test do
    system 'false'
  end
end
