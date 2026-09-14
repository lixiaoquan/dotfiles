#!/bin/bash

set -e

# Install direnv
mkdir -p "$HOME/.local/bin"
cp "$HOME/packages/direnv.linux-amd64" "$HOME/.local/bin/direnv"
chmod a+x "$HOME/.local/bin/direnv"

echo "direnv installed to $HOME/.local/bin/direnv"
"$HOME/.local/bin/direnv" version
# Install direnv end
