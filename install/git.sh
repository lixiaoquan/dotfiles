#!/bin/bash

set -e

# Install git
mkdir -p build_package
cd build_package
tar zxvf $HOME/packages/git-2.32.0.tar.gz
cd git-2.32.0
./configure --prefix=$HOME/local
make -j8
make install
cd
# Install git end

