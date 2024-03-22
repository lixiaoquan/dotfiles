#!/bin/bash

set -e

# Install zsh
mkdir -p ~/aarch64_local

$HOME/dotfiles/install/install_zsh -f $HOME/packages/zsh-5.8-linux-aarch64.tar.gz -d ~/aarch64_local -e no
# Install zsh end

