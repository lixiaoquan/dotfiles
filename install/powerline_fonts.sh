#!/bin/bash

set -e

# Install fonts
mkdir -p build_package
cd build_package
rm -rf fonts
cp -r $HOME/packages/fonts .
cd fonts
git reset
git checkout .
./install.sh

echo 'gnome-terminal Edit->Profile Preference->Custom Font-> Ubuntu Mono derivative Powerline Regular'
cd
# Install fonts end

