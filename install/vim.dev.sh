#!/bin/bash

set -e

# Install vim
mkdir -p build_package
cd build_package
rm -rf vim
cp -r $HOME/packages/vim .
cd vim
git reset
git checkout .
git checkout v8.2.2815
./configure --prefix=$HOME/vim.dev
make -j8
make install
cd
# Install vim end

