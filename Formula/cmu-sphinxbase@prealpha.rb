require "formula"

class CmuSphinxbaseAT5prealpha < Formula
  homepage "http://cmusphinx.sourceforge.net/"
  # NOTE: https://github.com/Homebrew/brew/blob/master/docs/Building-Against-Non-Homebrew-Dependencies.md
  # If you wish to build against custom non-Homebrew dependencies that are provided by Homebrew (e.g. a non-Homebrew, non-macOS ruby) then you must create and maintain your own tap as these formulae will not be accepted in Homebrew/homebrew-core. Once you have done that you can specify env :std in the formula which will allow a e.g. which ruby to access your existing PATH variable and allow compilation to link against this Ruby.

  # We only have special support for finding depends_on :python, but not yet for
  # :ruby, :perl etc., so we use the standard environment that leaves the
  # PATH as the user has set it right now.
  # env :std

  head do
    url "https://github.com/cmusphinx/sphinxbase.git"
    # branch "74370799d5b53afc5b5b94a22f5eff9cb9907b97"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "swig" => :build
    depends_on "pkg-config" => :build
    depends_on "gstreamer" => :build
    depends_on "gst-plugins-base" => :build
    depends_on "gst-plugins-good" => :build
  end


  stable do
    # the latest commit on the stable branch
    url "https://github.com/cmusphinx/sphinxbase.git",
        :revision => "74370799d5b53afc5b5b94a22f5eff9cb9907b97"
    version "74370799d5b53afc5b5b94a22f5eff9cb9907b97"

  end

  # We only have special support for finding depends_on :python, but not yet for
  # :ruby, :perl etc., so we use the standard environment that leaves the
  # PATH as the user has set it right now.
  # env :std

  # If these are found, they will be linked against and there is no configure
  # switch to turn them off.
  depends_on "libsndfile"
  depends_on "libsamplerate" => "with-libsndfile"
  depends_on "swig"

  option "without-python", "Build without python 3 support"
  option "with-python@2", "Build with python 2 support"

  depends_on "python@2" => :optional
  depends_on "python" => :recommended
  # depends_on "pygobject3" if build.with? "python"

  depends_on "gstreamer"
  depends_on "gst-plugins-base"
  depends_on "gst-plugins-good"

  def install
    # FIXME: Enable this??? 8/30/2018
    # SOURCE: https://github.com/Homebrew/homebrew-core/blob/master/Formula/python@2.rb
    # # Unset these so that installing pip and setuptools puts them where we want
    # # and not into some other Python the user has installed.
    # ENV["PYTHONHOME"] = nil
    # ENV["PYTHONPATH"] = nil

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
