class GstPluginsBad < Formula
  desc 'GStreamer plugins less supported, not fully tested'
  homepage 'https://gstreamer.freedesktop.org/'
  url 'https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.12.4.tar.xz'
  sha256 '0c7857be16686d5c1ba6e34bd338664d3d4599d32714a8eca5c8a41a101e2d08'

  bottle do
    root_url 'https://lfto.me/static/bottle'
  end

  head do
    url 'https://anongit.freedesktop.org/git/gstreamer/gst-plugins-bad.git'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
  end

  option 'with-opengl', 'Enable OpenGL (needed for some components (like wayland)' # not supported properly by formula yet.

  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build

  depends_on 'bossjones/scarlett-deps/gst-plugins-base'
  depends_on 'gettext'

  depends_on 'orc' => :recommended
  depends_on 'openssl' => :recommended
  depends_on 'libssh2' => :recommended
  depends_on 'libx11' => :recommended
  depends_on 'libuvc' => :recommended
  depends_on 'curl' => :recommended
  depends_on 'libvorbis' => :recommended
  depends_on 'jpeg-turbo' => :recommended
  depends_on 'rtmpdump' => :recommended
  depends_on 'gnutls' => :recommended
  depends_on 'libexif' => :recommended
  depends_on 'srtp' => :recommended
  depends_on 'dssim' => :recommended
  depends_on 'libav' => :recommended
  depends_on 'aalib' => :recommended
  depends_on 'libva' => :recommended
  depends_on 'webp' => :recommended
  depends_on 'opus' => :recommended
  depends_on 'x265' => :recommended
  depends_on 'libmpeg2' => :recommended
  # depends_on "openh264" => :recommended # fix openh264 formula first

  depends_on 'nettle' => :optional # use nettle instead of openssl?
  depends_on 'libgcrypt' => :optional # use libgcrypt instead of openssl?

  depends_on 'wayland' => :optional # requires EGL
  depends_on 'opencv' => :optional
  depends_on 'qt' => :optional
  depends_on 'openexr' => :optional
  depends_on 'graphene' => :optional
  depends_on 'libbs2b' => :optional
  depends_on 'chromaprint' => :optional
  depends_on 'libgsm' => :optional
  depends_on 'sdl' => :optional
  depends_on 'opus' => :optional
  depends_on 'libdca' => :optional
  depends_on 'musepack' => :optional
  depends_on 'libmms' => :optional
  depends_on 'libkate' => :optional
  depends_on 'dirac' => :optional
  depends_on 'faac' => :optional
  depends_on 'faad2' => :optional
  depends_on 'fdk-aac' => :optional
  depends_on 'gtk+3' => :optional
  depends_on 'libdvdread' => :optional
  depends_on 'schroedinger' => :optional
  depends_on 'sound-touch' => :optional
  depends_on 'libvo-aacenc' => :optional
  depends_on 'libbs2b' => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-experimental
      --disable-debug
      --disable-dependency-tracking
      --enable-orc=#{build.with?('orc') ? 'yes' : 'no'}
      --enable-opengl=#{build.with?('opengl') ? 'yes' : 'no'}
      --enable-gles2=#{build.with?('opengl') ? 'yes' : 'no'}
      --enable-egl=#{build.with?('opengl') ? 'yes' : 'no'}
      --enable-wgl=#{build.with?('opengl') ? 'yes' : 'no'}
      --enable-glx=#{build.with?('opengl') ? 'yes' : 'no'}
    ]

    if build.head?
      # autogen is invoked in "stable" build because we patch configure.ac
      ENV['NOCONFIGURE'] = 'yes'
      system './autogen.sh'
    end

    system './configure', *args
    system 'make'
    system 'make', 'install'
  end

  test do
    gst = Formula['gstreamer'].opt_bin / 'gst-inspect-1.0'
    assert_match version.to_s, shell_output("#{gst} --plugin aiff")
    assert_match version.to_s, shell_output("#{gst} --plugin bz2") # This always gets installed (probably indirect dep)
    assert_match version.to_s, shell_output("#{gst} --plugin curl") if build.with? 'curl'
    assert_match version.to_s, shell_output("#{gst} --plugin faac") if build.with? 'faac'
    assert_match version.to_s, shell_output("#{gst} --plugin fdkaac") if build.with? 'fdk-aac'
    assert_match version.to_s, shell_output("#{gst} --plugin opencv") if build.with? 'opencv'
    assert_match version.to_s, shell_output("#{gst} --plugin openexr") if build.with? 'openexr'
    assert_match version.to_s, shell_output("#{gst} --plugin opus") if build.with? 'opus'
    assert_match version.to_s, shell_output("#{gst} --plugin rtmp") if build.with? 'rtmpdump'
    assert_match version.to_s, shell_output("#{gst} --plugin webp") if build.with? 'webp'
    assert_match version.to_s, shell_output("#{gst} --plugin x265") if build.with? 'x265'
    assert_match version.to_s, shell_output("#{gst} --plugin chromaprint") if build.with? 'chromaprint'
    assert_match version.to_s, shell_output("#{gst} --plugin faad") if build.with? 'faad2'
    assert_match version.to_s, shell_output("#{gst} --plugin gtk") if build.with? 'gtk+3'
    assert_match version.to_s, shell_output("#{gst} --plugin kate") if build.with? 'libkate'
    assert_match version.to_s, shell_output("#{gst} --plugin mpeg2enc") if build.with? 'libmpeg2'
    assert_match version.to_s, shell_output("#{gst} --plugin openh264") if build.with? 'openh264'
  end
end
