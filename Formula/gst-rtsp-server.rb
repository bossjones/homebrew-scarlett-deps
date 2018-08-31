class GstRtspServer < Formula
  desc 'RTSP server library based on GStreamer'
  homepage 'https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html'
  url 'https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.12.4.tar.xz'
  sha256 '7660112ebd59838f1054796b38109dcbe32f0a040e3a252a68a81055aeaa56a9'

  bottle do
  end

  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'bossjones/scarlett-deps/gst-plugins-base'
  depends_on 'gobject-introspection'

  def install
    system './configure', "--prefix=#{prefix}",
           '--disable-debug',
           '--disable-dependency-tracking',
           '--disable-silent-rules',
           '--disable-examples',
           '--disable-tests',
           '--enable-introspection=yes'

    system 'make', 'install'
  end

  test do
    gst = Formula['gstreamer'].opt_bin / 'gst-inspect-1.0'
    output = shell_output("#{gst} --gst-plugin-path #{lib} --plugin rtspclientsink")
    assert_match /\s#{version.to_s}\s/, output
  end
end
