#!/bin/bash

# Helper to download tools

cd
mkdir -p packages
cd packages
wget -c https://ftp.nluug.nl/pub/vim/unix/vim-8.2.tar.bz2
wget -c https://nodejs.org/dist/v12.16.2/node-v12.16.2-linux-x64.tar.xz
wget -c https://github.com/clangd/clangd/releases/download/12.0.0/clangd-linux-12.0.0.zip
wget -c https://github.com/jesseduffield/lazygit/releases/download/v0.28.2/lazygit_0.28.2_Linux_x86_64.tar.gz


