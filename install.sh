#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="bashrc vimrc vim cheat tmux.conf gitconfig pip dircolors \
       bash_aliases_internal bash_aliases_external \
       tigrc bash_profile zshrc p10k.zsh"    # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

# Config different email according to host
if [ $HOSTNAME = "ops-Alienware-17-R4" ]; then
  ln -s $dir/gitconfig-email-github ~/.gitconfig-email
else
  ln -s $dir/gitconfig-email-work ~/.gitconfig-email
fi
