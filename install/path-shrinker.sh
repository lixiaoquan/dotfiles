#!/bin/bash

set -e

# Install
cd
filename=path-shrinker_0.1.1_Linux_x86_64/bin/path-shrinker
tar zxvf $HOME/packages/path-shrinker_0.1.1_Linux_x86_64.tar.gz $filename
mkdir -p $HOME/local
mkdir -p $HOME/local/bin
mv $filename $HOME/local/bin

# clean up
rm -rf path-shrinker_0.1_Linux_x86_64

# Install end

