# homebrew-scarlett-deps
Custom formulas to install/compile scarlett dependencies



# homebrew-scarlett-deps

[![Build Status](http://img.shields.io/travis/bossjones/homebrew-scarlett-deps.svg?style=flat)](https://travis-ci.org/bossjones/homebrew-scarlett-deps)

[Homebrew](http://brew.sh/) head-only [tap](https://github.com/Homebrew/homebrew/wiki/brew-tap) for [CMU Sphinx](http://cmusphinx.sourceforge.net/). Please see caveats for using head-only versions [here](https://github.com/Homebrew/homebrew-headonly#why-is-head-only-bad).

This has been tested on OSX Mavericks 10.9.5 and Yosemite 10.10.3. Feedback for other versions welcomed.

A lot of functionality has been added since the last stable CMU sphinx release (0.8) at the end of 2012. Most notably for OSX users this includes [support for the OpenAL audio backend](https://github.com/cmusphinx/sphinxbase/commit/5cc55c4721273681200e1f754ff0798ac073b950) which fixes [this bug](http://sourceforge.net/p/cmusphinx/bugs/389/) and supports live audio recognition on OSX.

There is also currently no stable [Sphinxtrain](https://github.com/cmusphinx/sphinxtrain) formula in the main Homebrew repository.


## Usage

Add the Homebrew tap:

```bash
$ brew tap bossjones/scarlett-deps
```

You'll see some warnings as these formulae conflict with those in the main reponitory, but that's fine.

Install the libraries:

```bash
$ brew install --HEAD bossjones/scarlett-deps/cmu-sphinxbase
$ brew install --HEAD bossjones/scarlett-deps/cmu-sphinxtrain # optional
$ brew install --HEAD bossjones/scarlett-deps/cmu-pocketsphinx
```

You can test continuous recognition as follows:

```bash
$ pocketsphinx_continuous -inmic yes
```

### Re-installing

To re-install, uninstall before following the instructions above:

```bash
$ brew uninstall cmu-sphinxbase
$ brew uninstall cmu-sphinxtrain
$ brew uninstall cmu-pocketsphinx
```


## Troubleshooting

Please be aware that these are development versions of CMU Sphinx packages and as such are expected to be unstable. You can submit bugs [here](https://sourceforge.net/p/cmusphinx/bugs/).

**syntax error near unexpected token no-define' ./configure: line 2366:AM_INIT_AUTOMAKE(no-define foreign)'**

A few people seem to be experiencing this error (as descibed in #2). The solution seems to be to run the following and retry:

```bash
$ brew doctor
$ brew prune
```

--------------------------------

# homebrew-gstreamer
A brew repository for the latest Gstreamer framework and plugins

Sadly, the core repository contains very outdated, missing, or badly written formulas for gstreamer.
I've made this repo to have an always up to date repo for installing the latest gstreamer framework, and all of its plugins.

This is for linux only. Use with linuxbrew.

# Tapping
`brew tap bossjones/scarlett-deps`

# Installing packages
I've kept the naming scheme used upstream, and in the core repos.
Install packages the same as you would from core, just use this form: `bossjones/scarlett-deps/<FORMULA>`
For example to install gstreamer, use: `brew install bossjones/scarlett-deps/gstreamer`

## Installing everything :)
A quick copy+paste solution to install all the packages provided here.
``` bash
brew install bossjones/scarlett-deps/gst-plugins-good bossjones/scarlett-deps/gst-plugins-bad bossjones/scarlett-deps/gst-plugins-ugly bossjones/scarlett-deps/gst-libav bossjones/scarlett-deps/gst-rtsp-server bossjones/scarlett-deps/gstreamer-vaapi
```
and
``` bash
brew install bossjones/scarlett-deps/gst-python --with-python3 --without-python
```

# homebrew python

If you want to use the Python version bundled with OS X, you’ll need to include Python packages installed by Homebrew in your `PYTHONPATH`. If you don’t do this, the scarlett-cli executable will not find its dependencies and will crash.

You can either amend your `PYTHONPATH` permanently, by adding the following statement to your shell’s init file, e.g. `~/.bashrc`:

`export PYTHONPATH=$(brew --prefix)/lib/python3.7/site-packages:$PYTHONPATH`

And then reload the shell’s init file or restart your terminal:

`source ~/.bashrc`

Or, you can prefix the scarlett-cli command every time you run it:

`PYTHONPATH=$(brew --prefix)/lib/python3.7/site-packages scarlett-cli`

# Inspiration from
- https://github.com/half2me/homebrew-gstreamer
- https://github.com/Homebrew/brew/blob/master/docs/How-to-Create-and-Maintain-a-Tap.md
- https://github.com/watsonbox/homebrew-cmu-sphinx
