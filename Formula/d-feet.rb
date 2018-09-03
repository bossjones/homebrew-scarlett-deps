require 'formula'

class DFeet < Formula
  homepage 'https://wiki.gnome.org/Apps/DFeet'

  head do
    url 'https://github.com/GNOME/d-feet'
    # branch "0.3.10"
    depends_on 'python@2' => :build
    depends_on 'python' => :build
    depends_on 'gtk+3' => :build
    depends_on 'pygobject3' => :build
    depends_on 'gobject-introspection' => :build
    depends_on 'gettext' => :build
    depends_on 'xz' => :build # For LZMA
    depends_on 'yasm' => :build
    depends_on 'dbus' => :build
  end

  stable do
    # the latest commit on the stable branch
    url 'https://github.com/GNOME/d-feet',
        revision: '0.3.10'
    version '0.3.10'
  end

  devel do
    # some other things...
    url 'https://github.com/GNOME/d-feet',
        revision: '0.3.10'
    version '0.3.10'
  end

  # We only have special support for finding depends_on :python, but not yet for
  # :ruby, :perl etc., so we use the standard environment that leaves the
  # PATH as the user has set it right now.
  # env :std

  depends_on 'pkg-config' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  option 'without-python', 'Build without python 3 support'
  option 'with-python@2', 'Build with python 2 support'
  option 'with-python', 'Use the Homebrew version of Python; by default system Python is used'
  option 'with-python@2', 'Use the Homebrew version of Python 2; by default system Python is used'

  depends_on 'python@2' => :optional
  depends_on 'python' => :optional
  depends_on 'gtk+3'
  depends_on 'pygobject3'
  depends_on 'gobject-introspection' => :build
  depends_on 'gettext'
  depends_on 'xz' # For LZMA
  depends_on 'yasm' => :build
  depends_on 'dbus'

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

    system './autogen.sh'

    system './configure', *args
    system 'make', 'install'
  end
end
