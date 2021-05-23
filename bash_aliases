# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Level 0 alias
alias t='top'
alias v='~/local/bin/vim'
alias n='ninja'
alias f="find . -type f -iname"
alias b="cd -"
alias p='pytest -v --disable-warnings'
alias e='exit'
alias c='git clean -fX'
alias z='lazygit'

# Other aliases
alias ll='ls -alF'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ..&& cd ..'
alias rm='rm -rf'
alias vi='vim'
alias reload='source $HOME/.bashrc'
alias showalias='cat $HOME/.bash_aliases'
alias p1='patch --no-backup-if-mismatch -p1 <'
alias ni='ninja'
alias nr='ninja rebase'
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
alias ff="find . -type f -iname"
alias skill="sudo kill"
alias lh='cd /LocalRun/xiaoquan.li'

alias pytest='pytest -v --disable-warnings'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# copy the current working directory to the clipboard
alias cpwd='pwd | xclip -selection clipboard'

alias gdb='gdb -q'
