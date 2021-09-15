#!/bin/bash

set -e

# Install fonts
cd $HOME/packages/nerd-fonts
./install.sh UbuntuMono

echo 'gnome-terminal Edit->Profile Preference->Allow blinking text-> Never'
echo 'gnome-terminal Edit->Profile Preference->Custom Font-> UbuntuMono Nerd Font Mono Regular'
cd
# Install fonts end

