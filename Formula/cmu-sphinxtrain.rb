require 'formula'

class CmuSphinxtrain < Formula
  homepage 'http://cmusphinx.sourceforge.net/'
  head 'https://github.com/cmusphinx/sphinxtrain.git'

  depends_on 'pkg-config' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  depends_on 'bossjones/scarlett-deps/cmu-sphinxbase'

  def install
    system './autogen.sh'
    system './configure', '--disable-dependency-tracking',
           "--prefix=#{prefix}"
    system 'make', 'install'
  end
end
