#!/bin/bash

set -e

# Install tmux
mkdir -p build_package
cd build_package

tar xvzf $HOME/packages/libevent-2.1.12-stable.tar.gz
cd libevent-2.1.12-stable
./configure --prefix=$HOME/local --disable-shared
make -j8
make install
cd -

tar xvzf $HOME/packages/ncurses-6.2.tar.gz
cd ncurses-6.2
./configure --prefix=$HOME/local
make -j8
make install
cd -

tar zxvf $HOME/packages/tmux-3.2a.tar.gz
cd tmux-3.2a
./configure CFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-L$HOME/local/lib -L$HOME/local/include/ncurses -L$HOME/local/include" CPPFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-static -L$HOME/local/include -L$HOME/local/include/ncurses -L$HOME/local/lib" --prefix=$HOME/local
make -j8
make install
cd
# Install tmux end

