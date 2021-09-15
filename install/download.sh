#!/bin/bash

# Helper to download tools

cd
mkdir -p packages
cd packages
wget -c https://nodejs.org/dist/v14.17.5/node-v14.17.5-linux-x64.tar.xz
wget -c https://github.com/clangd/clangd/releases/download/12.0.0/clangd-linux-12.0.0.zip
wget -c https://github.com/jesseduffield/lazygit/releases/download/v0.29/lazygit_0.29_Linux_x86_64.tar.gz
wget -c https://github.com/tmux/tmux/releases/download/2.6/tmux-2.6.tar.gz
wget -c https://www.kernel.org/pub/software/scm/git/git-2.32.0.tar.gz
wget -c https://github.com/neovim/neovim/releases/download/v0.5.0/nvim-linux64.tar.gz

if [ -d vim ]; then
  cd vim
  git reset
  git checkout .
  git pull
  cd -
else
  git clone https://github.com/vim/vim.git
fi

# powerline fonts
if [ -d fonts ]; then
  cd fonts
  git reset
  git checkout .
  git pull
  cd -
else
  git clone https://github.com/powerline/fonts.git --depth=1
fi

if [ -d nerd-fonts ]; then
  cd nerd-fonts
  git reset
  git checkout .
  git pull
else
  git clone --depth=1 https://hub.fastgit.org/ryanoasis/nerd-fonts.git
fi

