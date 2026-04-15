#!/bin/bash

set -e

# Install rtk
cd
rm -rf rtk
tar zxvf $HOME/packages/rtk-x86_64-unknown-linux-musl.tar.gz rtk
mkdir -p $HOME/local
mkdir -p $HOME/local/bin
mv rtk $HOME/local/bin
# Install rtk end
