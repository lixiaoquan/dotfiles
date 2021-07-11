#!/bin/bash

# Helper to download tools

cd
mkdir -p packages
cd packages
wget -c https://ftp.nluug.nl/pub/vim/unix/vim-8.2.tar.bz2
wget -c https://nodejs.org/dist/v12.16.2/node-v12.16.2-linux-x64.tar.xz
wget -c https://github.com/clangd/clangd/releases/download/12.0.0/clangd-linux-12.0.0.zip
wget -c https://github.com/jesseduffield/lazygit/releases/download/v0.28.2/lazygit_0.28.2_Linux_x86_64.tar.gz
wget -c https://github.com/tmux/tmux/releases/download/2.6/tmux-2.6.tar.gz
wget -c https://www.kernel.org/pub/software/scm/git/git-2.32.0.tar.gz

if [ -d vim ]; then
  cd vim
  git reset
  git checkout .
  git pull
  cd -
else
  git clone https://github.com/vim/vim.git
fi


