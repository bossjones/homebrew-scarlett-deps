class GstreamerVaapi < Formula
  desc "Hardware-accelerated video decoding, encoding and processing on Intel graphics through VA-API"
  homepage "https://github.com/GStreamer/gstreamer-vaapi/"
  url "https://gstreamer.freedesktop.org/src/gstreamer-vaapi/gstreamer-vaapi-1.12.4.tar.xz"
  sha256 "1c2d77242e1f30c4d1394636cae9f6877228a017960fca96881e0080d8b6e9c9"

  bottle do
    root_url "https://lfto.me/static/bottle"
  end

  head "https://github.com/GStreamer/gstreamer-vaapi.git"

  depends_on "pkg-config" => :build

  depends_on "bossjones/scarlett-deps/gst-plugins-bad"
  depends_on "linuxbrew/xorg/wayland" => :recommended
  depends_on "linuxbrew/xorg/libdrm" => :recommended
  depends_on "linuxbrew/xorg/libx11" => :recommended

  def caveats
    <<~EOS
      You must install a libva driver for this package to work. (e.g.: `brew install libva-intel-driver`)
    EOS
  end

  depends_on "linuxbrew/xorg/systemd" if build.with?("libdrm")

  depends_on "linuxbrew/xorg/libva"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-debug
      --disable-silent-rules
      --disable-examples
      --enable-static=#{build.with?("static") ? "yes" : "no"}
      --enable-encoders=#{build.with?("encoders") ? "yes" : "no"}
      --enable-drm=#{build.with?("libdrm") ? "yes" : "no"}
      --enable-x11=#{build.with?("libx11") ? "yes" : "no"}
      --enable-glx=#{build.with?("eglx") ? "yes" : "no"}
      --enable-egl=#{build.with?("eglx") ? "yes" : "no"}
      --enable-wayland=#{build.with?("wayland") ? "yes" : "no"}
    ]

    if build.head?
      # autogen is invoked in "stable" build because we patch configure.ac
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin vaapi")
    assert_match version.to_s, output
  end
end
