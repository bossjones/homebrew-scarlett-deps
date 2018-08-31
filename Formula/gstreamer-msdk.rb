class GstreamerMsdk < Formula
  desc 'GStreamer plugins for Intel Media SDK'
  homepage 'https://github.com/ishmael1985/gstreamer-media-SDK'
  url 'https://github.com/ishmael1985/gstreamer-media-SDK/archive/2.0.0.tar.gz'
  sha256 'defdf8d943c77a2d7dd8a13748a8437c9d8cbc63fe132cd4fe90e01dae50b091'

  head 'https://github.com/ishmael1985/gstreamer-media-SDK.git'

  depends_on 'meson' => :build
  depends_on 'ninja' => :build

  depends_on 'bossjones/scarlett-deps/libva2'

  depends_on 'bossjones/scarlett-deps/gst-plugins-bad'
  depends_on 'bossjones/scarlett-deps/mfx-dispatch'
  depends_on 'bossjones/scarlett-deps/libdrm'
  depends_on 'systemd'
  depends_on 'libxkbcommon'

  depends_on 'linuxbrew/xorg/mesa' => :optional
  depends_on 'linuxbrew/xorg/wayland' => :optional
  depends_on 'linuxbrew/xorg/libx11' => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --buildtype=release
      --libdir=#{prefix}/lib
    ]

    # We patch the meson build file to search for "libmfx" instead of "mfx"
    file_name = 'meson.build'
    text = File.read(file_name)
    new_contents = text.gsub("dependency('mfx'", "dependency('libmfx'")
    File.open(file_name, 'w') { |file| file.puts new_contents }

    system 'meson', 'build', *args
    system 'ninja', '-C', 'build', 'install'
  end

  test do
    gst = Formula['gstreamer'].opt_bin / 'gst-inspect-1.0'
    output = shell_output("#{gst} --plugin msdk")
    assert_match version.to_s, output
  end
end
