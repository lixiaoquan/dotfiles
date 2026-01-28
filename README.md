# Install
## Install basic
```bash
./install.sh
```
## Download tools
```bash
install/download.sh
```
## Install tools
```bash
install/tmux.sh
install/powerline_fonts.sh
install/zsh.sh
install/ohmyzsh.sh
install/fzf.sh
install/node.sh
install/vim.dev.sh
install/git.sh
install/lazygit.sh
install/clangd.sh
...
```

## Install skills
```bash
cd ~/.claude
ln -s ~/dotfiles/skills .
```

## Troubleshooting
### Build zsh with error about cur_term
apt install libncurses-dev


## Update nvim plugin
1. PlugUpdate
2. CocUpdate
3. TSUpdate
4. sync dotfiles/vim and dotfiles/config/coc/extensions


## gitstatusd for powerlevel10
Copy downloaded binary ~/.cache/gitstatus/gitstatusd-linux-x86_64 to machines without internet access
