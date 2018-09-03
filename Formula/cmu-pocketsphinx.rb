require 'formula'

# INSPIRATION: https://github.com/Homebrew/homebrew-core/blob/master/Formula/ipython@5.rb
class CmuPocketsphinx < Formula
  desc 'Lightweight speech recognition engine for mobile devices 5prealpha'
  homepage 'https://cmusphinx.sourceforge.io/'

  # NOTE: https://github.com/Homebrew/brew/blob/master/docs/Building-Against-Non-Homebrew-Dependencies.md
  # If you wish to build against custom non-Homebrew dependencies that are provided by Homebrew (e.g. a non-Homebrew, non-macOS ruby) then you must create and maintain your own tap as these formulae will not be accepted in Homebrew/homebrew-core. Once you have done that you can specify env :std in the formula which will allow a e.g. which ruby to access your existing PATH variable and allow compilation to link against this Ruby.

  # We only have special support for finding depends_on :python, but not yet for
  # :ruby, :perl etc., so we use the standard environment that leaves the
  # PATH as the user has set it right now.
  # env :std
  head do
    url 'https://github.com/cmusphinx/pocketsphinx.git'
    # branch "68ef5dc6d48d791a747026cd43cc6940a9e19f69"
    depends_on 'gstreamer' => :build
    depends_on 'gst-plugins-base' => :build
    depends_on 'gst-plugins-good' => :build
  end

  stable do
    # the latest commit on the stable branch
    url 'https://github.com/cmusphinx/pocketsphinx.git',
        revision: '68ef5dc6d48d791a747026cd43cc6940a9e19f69'
    version '68ef5dc6d48d791a747026cd43cc6940a9e19f69'
  end

  # We only have special support for finding depends_on :python, but not yet for
  # :ruby, :perl etc., so we use the standard environment that leaves the
  # PATH as the user has set it right now.
  # env :std

  depends_on 'pkg-config' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'swig' => :build

  # If these are found, they will be linked against and there is no configure
  # switch to turn them off.
  depends_on 'libsndfile'
  depends_on 'libsamplerate' => 'with-libsndfile'
  depends_on 'swig'

  option 'without-python', 'Build without python 3 support'
  option 'with-python@2', 'Build with python 2 support'
  option 'with-python', 'Use the Homebrew version of Python; by default system Python is used'
  option 'with-python@2', 'Use the Homebrew version of Python 2; by default system Python is used'

  depends_on 'python@2' => :optional
  depends_on 'python' => :optional
  # depends_on "pygobject3" if build.with? "python"

  depends_on 'openal-soft' => :build
  depends_on 'gstreamer' => :build
  depends_on 'gst-plugins-base' => :build
  depends_on 'gst-plugins-good' => :build
  depends_on 'gst-plugins-bad' => :build
  depends_on 'gst-plugins-ugly' => :build
  depends_on 'pulseaudio'
  depends_on 'bossjones/scarlett-deps/cmu-sphinxbase'

  def install
    args = [
      "--prefix=#{prefix}",
      '--disable-debug',
      '--disable-dependency-tracking'
    ]

    if build.with?('python@2') && build.with?('python')
      odie 'Options --with-python and --with-python@2 are mutually exclusive.'
    elsif build.with?('python@2')
      args << "--with-python=#{Formula['python@2'].opt_bin}/python2"
      ENV.append 'CPPFLAGS', "-I#{Formula['python@2'].opt_libexec}"
    elsif build.with?('python')
      args << "--with-python=#{Formula['python'].opt_bin}/python3"
      ENV.append 'CPPFLAGS', "-I#{Formula['python'].opt_libexec}"
    else
      args << '--with-python=/usr'
    end

    xy = Language::Python.major_minor_version 'python3'
    ENV.prepend_create_path 'PYTHONPATH', libexec / "vendor/lib/python#{xy}/site-packages"
    ENV.prepend_path 'PATH', Formula['python'].opt_libexec / 'bin'
    ENV['PYTHON'] = "python#{xy}"
    ENV['GST_PLUGIN_PATH'] = "#{HOMEBREW_PREFIX}/lib/gstreamer-1.0"

    ENV.prepend_path 'PKG_CONFIG_PATH', Formula['cmu-sphinxbase'].opt_lib / '/pkgconfig'

    # FIXME: Enable this??? 8/30/2018
    # SOURCE: https://github.com/Homebrew/homebrew-core/blob/master/Formula/python@2.rb
    # # Unset these so that installing pip and setuptools puts them where we want
    # # and not into some other Python the user has installed.
    # ENV["PYTHONHOME"] = nil
    # ENV["PYTHONPATH"] = nil
    system './autogen.sh'

    # SOURCE: https://github.com/Homebrew/homebrew-core/blob/eced86fcce9e92b7d7e7d1a1cee960c994fab0cd/Formula/gstreamer.rb
    # Look for plugins in HOMEBREW_PREFIX/lib/gstreamer-1.0 instead of
    # HOMEBREW_PREFIX/Cellar/gstreamer/1.0/lib/gstreamer-1.0, so we'll find
    # plugins installed by other packages without setting GST_PLUGIN_PATH in
    # the environment.

    system './configure', *args
    system 'make', 'install'
  end

  test do
    system "#{bin}/gst-inspect-1.0", 'pocketsphinx'
  end
end
