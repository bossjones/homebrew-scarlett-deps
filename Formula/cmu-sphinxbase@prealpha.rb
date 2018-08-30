require "formula"

class CmuSphinxbaseAT5prealpha < Formula
  homepage "http://cmusphinx.sourceforge.net/"
  head "https://github.com/cmusphinx/sphinxbase.git"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # If these are found, they will be linked against and there is no configure
  # switch to turn them off.
  depends_on "libsndfile"
  depends_on "libsamplerate" => "with-libsndfile"
  depends_on "swig"

  option "without-python", "Build without python 3 support"
  option "with-python@2", "Build with python 2 support"

  depends_on "python@2" => :optional
  depends_on "python" => :recommended
  depends_on "pygobject3" if build.with? "python"

  def install
    if build.with?("python") && build.with?("python@2")
      # Upstream does not support having both Python2 and Python3 versions
      # of the plugin installed because apparently you can load only one
      # per process, so GStreamer does not know which to load.
      odie "You must pass both --without-python and --with-python@2 for python 2 support"
    end

    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
