#!/bin/bash

set -euo pipefail

install_dir="$HOME/local/bin"
tmp_dir="$(mktemp -d)"

cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

# Download JFrog CLI to a temporary directory.
(
  cd "$tmp_dir"
  curl -fL https://getcli.jfrog.io/v2-jf | sh
)

# Copy it into the user-local bin directory.
mkdir -p "$install_dir"
cp -f "$tmp_dir/jf" "$install_dir/jf"
chmod +x "$install_dir/jf"

echo "JFrog CLI installed to $install_dir/jf"
"$install_dir/jf" --version
