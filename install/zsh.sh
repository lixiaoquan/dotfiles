#!/bin/bash

set -e

# Install zsh
mkdir -p build_package
cd build_package
tar xf $HOME/packages/zsh-5.8.tar.xz
cd zsh-5.8
./configure --prefix=$HOME/local
make -j8
make install
cd
# Install zsh end

