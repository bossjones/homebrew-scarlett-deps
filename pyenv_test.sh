#!/usr/bin/env bash

# env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install 3.7.0

# pyenv virtualenv 3.7.0 scarlett-deps37

# pyenv virtualenv --system-site-packages 3.7.0 scarlett-deps37

# pyenv activate scarlett-deps37

env PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig" pip install pygobject==3.28.3 ptpython black isort ipython pdbpp Pillow matplotlib numpy_ringbuffer MonkeyType

export LD_LIBRARY_PATH=/usr/local/lib
# export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
