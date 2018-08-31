class GstPluginsGood < Formula
  desc 'GStreamer plugins (well-supported, under the LGPL)'
  homepage 'https://gstreamer.freedesktop.org/'
  url 'https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.12.4.tar.xz'
  sha256 '649f49bec60892d47ee6731b92266974c723554da1c6649f21296097715eb957'

  bottle do
    root_url 'https://lfto.me/static/bottle'
  end

  head do
    url 'https://anongit.freedesktop.org/git/gstreamer/gst-plugins-good.git'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
    depends_on 'libtool' => :build
  end

  depends_on 'pkg-config' => :build

  depends_on 'bossjones/scarlett-deps/gst-plugins-base'
  depends_on 'gettext'

  depends_on 'orc' => :recommended
  depends_on 'libx11' => :recommended
  depends_on 'aalib' => :optional # doesn't work as of 12.4
  depends_on 'cairo' => :optional # doesn't work as of 12.4
  depends_on 'flac' => [:recommended, 'with-libogg']
  depends_on 'gdk-pixbuf' => :recommended
  depends_on 'jpeg-turbo' => :recommended
  depends_on 'libcaca' => :optional # doesn't work as of 12.4
  depends_on 'libdv' => :optional # doesn't work as of 12.4
  depends_on 'libpng' => :recommended
  depends_on 'libsoup' => :recommended
  depends_on 'taglib' => :recommended
  depends_on 'libvpx' => :recommended
  depends_on 'wavpack' => :recommended
  depends_on 'zlib' => :recommended
  depends_on 'bzip2' => :recommended

  depends_on 'jack' => :optional
  depends_on 'pulseaudio' => :optional
  depends_on 'libshout' => :optional
  depends_on 'speex' => :optional

  depends_on 'libogg' if build.with? 'flac'

  # oss4 and ossaudio seem to get installed... unsure of what their deps are. Also wavewormsink, 1394 are not installed
  def install
    args = %W[
      --prefix=#{prefix}
      --enable-experimental
      --disable-debug
      --disable-dependency-tracking
      --enable-v4l2-probe=yes
      --enable-orc=#{build.with?('orc') ? 'yes' : 'no'}
    ]

    if build.head?
      ENV['NOCONFIGURE'] = 'yes'
      system './autogen.sh'
    end

    system './configure', *args
    system 'make'
    system 'make', 'install'
  end

  test do
    gst = Formula['gstreamer'].opt_bin / 'gst-inspect-1.0'
    assert_match version.to_s, shell_output("#{gst} --plugin rtsp")
    assert_match version.to_s, shell_output("#{gst} --plugin aasink") if build.with?('aalib')
    assert_match version.to_s, shell_output("#{gst} --plugin cacasink") if build.with?('libcaca')
    assert_match version.to_s, shell_output("#{gst} --plugin cairo") if build.with?('cairo')
    assert_match version.to_s, shell_output("#{gst} --plugin dv") if build.with?('libdv')
    assert_match version.to_s, shell_output("#{gst} --plugin flac") if build.with?('flac')
    assert_match version.to_s, shell_output("#{gst} --plugin gdkpixbuf") if build.with?('gdkpixbuf')
    assert_match version.to_s, shell_output("#{gst} --plugin jpeg") if build.with?('jpeg')
    assert_match version.to_s, shell_output("#{gst} --plugin png") if build.with?('libpng')
    assert_match version.to_s, shell_output("#{gst} --plugin soup") if build.with?('libsoup')
    assert_match version.to_s, shell_output("#{gst} --plugin taglib") if build.with?('taglib')
    assert_match version.to_s, shell_output("#{gst} --plugin vpx") if build.with?('libvpx')
    assert_match version.to_s, shell_output("#{gst} --plugin wavpack") if build.with?('wavpack')
    assert_match version.to_s, shell_output("#{gst} --plugin ximagesrc") if build.with?('libx11')
    assert_match version.to_s, shell_output("#{gst} --plugin jack") if build.with?('jack')
    assert_match version.to_s, shell_output("#{gst} --plugin pulseaudio") if build.with?('pulseaudio')
    assert_match version.to_s, shell_output("#{gst} --plugin shout2") if build.with?('libshout')
    assert_match version.to_s, shell_output("#{gst} --plugin speex") if build.with?('speex')
  end
end
