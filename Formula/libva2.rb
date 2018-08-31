class Libva2 < Formula
  desc 'Libva is an implementation for VA-API (VIdeo Acceleration API)'
  homepage 'https://01.org/linuxmedia'
  url 'https://github.com/01org/libva/releases/download/2.0.0/libva-2.0.0.tar.bz2'
  sha256 'bb0601f9a209e60d8d0b867067323661a7816ff429021441b775452b8589e533'

  head do
    url 'https://github.com/01org/libva.git'
  end

  depends_on 'bossjones/scarlett-deps/libdrm'

  depends_on 'pkg-config' => :build

  depends_on 'wayland' => :recommended
  depends_on 'libx11' => :recommended

  def install
    system './configure', '--disable-debug',
           '--disable-dependency-tracking',
           '--disable-silent-rules',
           "--prefix=#{prefix}"
    system 'make', 'install'
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test libva`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system 'false'
  end
end
