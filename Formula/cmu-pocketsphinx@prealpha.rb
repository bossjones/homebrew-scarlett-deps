require "formula"

# INSPIRATION: https://github.com/Homebrew/homebrew-core/blob/master/Formula/ipython@5.rb
class CmuPocketsphinxATprealpha < Formula
  desc "Lightweight speech recognition engine for mobile devices 5prealpha"
  homepage "https://cmusphinx.sourceforge.io/"

  # NOTE: https://github.com/Homebrew/brew/blob/master/docs/Building-Against-Non-Homebrew-Dependencies.md
  # If you wish to build against custom non-Homebrew dependencies that are provided by Homebrew (e.g. a non-Homebrew, non-macOS ruby) then you must create and maintain your own tap as these formulae will not be accepted in Homebrew/homebrew-core. Once you have done that you can specify env :std in the formula which will allow a e.g. which ruby to access your existing PATH variable and allow compilation to link against this Ruby.

  # We only have special support for finding depends_on :python, but not yet for
  # :ruby, :perl etc., so we use the standard environment that leaves the
  # PATH as the user has set it right now.
  # env :std

  head do
    url "https://github.com/cmusphinx/pocketsphinx.git"
    branch "68ef5dc6d48d791a747026cd43cc6940a9e19f69"
    # head "https://github.com/python/cpython.git", :branch => "2.7"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "swig" => :build
  end

  option "without-python", "Build without python 3 support"
  option "with-python@2", "Build with python 2 support"

  depends_on "python@2" => :optional
  depends_on "python" => :recommended
  depends_on "pygobject3" if build.with? "python"
  depends_on "pkg-config" => :build
  depends_on "bossjones/scarlett-deps/cmu-sphinxbase@prealpha"
  depends_on "gstreamer"

  def install
    # FIXME: Enable this??? 8/30/2018
    # SOURCE: https://github.com/Homebrew/homebrew-core/blob/master/Formula/python@2.rb
    # # Unset these so that installing pip and setuptools puts them where we want
    # # and not into some other Python the user has installed.
    # ENV["PYTHONHOME"] = nil
    # ENV["PYTHONPATH"] = nil

    # INSPIRATION: https://github.com/Homebrew/homebrew-core/blob/master/Formula/ipython@5.rb#L146
    xy = Language::Python.major_minor_version "python"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    if build.with?("python") && build.with?("python@2")
      # Upstream does not support having both Python2 and Python3 versions
      # of the plugin installed because apparently you can load only one
      # per process, so GStreamer does not know which to load.
      odie "You must pass both --without-python and --with-python@2 for python 2 support"
    end

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
