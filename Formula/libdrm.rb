class Libdrm < Formula
  desc 'Library for accessing the direct rendering manager'
  homepage 'https://dri.freedesktop.org'
  url 'https://dri.freedesktop.org/libdrm/libdrm-2.4.89.tar.bz2'
  sha256 '629f9782aabbb4809166de5f24d26fe0766055255038f16935602d89f136a02e'

  bottle do
  end

  option 'without-test', 'Skip compile-time tests'
  option 'with-static', 'Build static libraries (not recommended)'
  option 'with-valgrind', 'Build libdrm with valgrind support'

  depends_on 'pkg-config' => :build
  depends_on 'linuxbrew/xorg/libpciaccess'
  depends_on 'cunit' if build.with? 'test'
  depends_on 'cairo' if build.with? 'test'
  depends_on 'valgrind' => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-udev
    ]
    args << "--enable-static=#{build.with?('static') ? 'yes' : 'no'}"

    system './configure', *args
    system 'make'
    system 'make', 'check' if build.with? 'test'
    system 'make', 'install'
  end
end
