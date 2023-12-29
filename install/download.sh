#!/bin/bash

# Helper to download tools

# github mirror
if [ -z "$github" ]; then
  github="hub.gitfast.tk"
fi

# github="github.com"

cd
mkdir -p packages
cd packages
wget -c https://${github}/oinume/path-shrinker/releases/download/v0.1.1/path-shrinker_0.1.1_Linux_x86_64.tar.gz
wget -c https://${github}/neovim/neovim/releases/download/v0.8.3/nvim.appimage
wget -c https://${github}/jesseduffield/lazygit/releases/download/v0.36.0/lazygit_0.36.0_Linux_x86_64.tar.gz
wget -c https://nodejs.org/dist/v16.18.0/node-v16.18.0-linux-x64.tar.xz
wget -c https://${github}/clangd/clangd/releases/download/17.0.3/clangd-linux-17.0.3.zip
wget -c https://${github}/ThomasLachaux/lazydocker-high-contrast/releases/download/v0.13-high-contrast/lazydocker
wget -c https://${github}/tmux/tmux/releases/download/3.2a/tmux-3.2a.tar.gz
wget -c https://www.kernel.org/pub/software/scm/git/git-2.32.0.tar.gz
wget -c https://www.zsh.org/pub/zsh-5.8.tar.xz
wget -c https://${github}/kovidgoyal/kitty/releases/download/v0.23.1/kitty-0.23.1-x86_64.txz
wget -c https://${github}/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
wget -c ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.2.tar.gz

# powerline fonts
if [ -d fonts ]; then
  cd fonts
  git reset
  git checkout .
  git pull
  cd -
else
  git clone https://${github}/powerline/fonts.git --depth=1
fi

if [ -d nerd-fonts ]; then
  cd nerd-fonts
  git reset
  git checkout .
  git pull
else
  git clone --depth=1 https://${github}/ryanoasis/nerd-fonts.git
fi

