#!/bin/bash

set -e

DOTFILE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Create ~/.claude directory if not exists
mkdir -p $HOME/.claude

# Link skills directory
if [ -L "$HOME/.claude/skills" ]; then
  # Already a symlink, remove it first
  rm "$HOME/.claude/skills"
elif [ -d "$HOME/.claude/skills" ]; then
  # Exists as a directory, backup it
  mv "$HOME/.claude/skills" "$HOME/.claude/skills.bak.$(date +%Y%m%d%H%M%S)"
  echo "Backed up existing skills directory"
fi

ln -s $DOTFILE_DIR/skills $HOME/.claude/skills
echo "Linked ~/.claude/skills -> $DOTFILE_DIR/skills"

echo "Claude skills installed successfully!"
