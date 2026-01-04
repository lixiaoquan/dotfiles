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

# Level 0 alias
alias a='cd /LocalRun/xiaoquan.li/artifactory'
alias b="cd -"
c () {
  cd "$@" && ls;
}
alias e='exit'
alias f="ag --unrestricted -i -g"
alias p='pytest -v --disable-warnings'
alias n='nice -n 20 ninja'
alias t='top'
alias v='nvim'
alias z='lazygit'

# Other aliases
alias ll='ls -alF'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ..&& cd ..'
alias rm='rm -rf'
alias vi='nvim'
alias reload='source $HOME/.bashrc'
alias showalias='cat $HOME/.bash_aliases'
alias p1='patch --no-backup-if-mismatch -p1 <'
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
alias ff="find . -type f -iname"
alias skill="sudo kill"
alias lh='cd /LocalRun/xiaoquan.li'

alias pytest='pytest -v --disable-warnings'

# copy the current working directory to the clipboard
alias cpwd='pwd | xclip -selection clipboard'

alias gdb='gdb -q'
alias dotfiles='cd $HOME/dotfiles'
alias vimrc='v $HOME/dotfiles/vimrc'

alias gci='git commit -a'
alias ga='git commit -a --amend'
alias gbr='git branch'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gpl='git pull --rebase'
alias gls='git log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate'
alias gcp='git cherry-pick'
alias gdc='git diff --cached'
alias gds='git diff --stat'
alias gr1='git reset HEAD^'
alias gr2='git reset HEAD^^'
alias gst='git stash'
alias gstp='git stash pop'
alias gr='git review'
alias gd='git diff'
alias gs='git status'
alias gf='git fetch --all'

alias lzd='TERM=screen-256color lazydocker'

alias justbash='NO_ZSH=1 bash'
alias cpv="rsync -ah --progress"


dlgpu() {
    if [ $# -lt 2 ]; then
        echo "Usage: dlgpu <gpu_ids> <command>"
        echo "Example: dlgpu 012 'python train.py'"
        echo "         dlgpu 01234567 'nvidia-smi'"
        return 1
    fi
    
    local gpu_ids="$1"
    shift
    
    # Convert gpu_ids string to comma-separated format
    local cuda_devices=""
    for (( i=0; i<${#gpu_ids}; i++ )); do
        local gpu_id="${gpu_ids:$i:1}"
        if [ $i -eq 0 ]; then
            cuda_devices="$gpu_id"
        else
            cuda_devices="$cuda_devices,$gpu_id"
        fi
    done
    
    echo "Running with CUDA_VISIBLE_DEVICES=$cuda_devices $*"
    CUDA_VISIBLE_DEVICES="$cuda_devices" "$@"
}

ks38() {
    if [ $# -lt 2 ]; then
        echo "Usage: ks38 <group_ids> <command>"
        echo "Example: ks38 0 'python train.py'     # Uses GPUs 0,1,2,3"
        echo "         ks38 1 'python train.py'     # Uses GPUs 4,5,6,7"
        echo "         ks38 01 'python train.py'    # Uses GPUs 0,1,2,3,4,5,6,7"
        return 1
    fi
    
    local group_ids="$1"
    shift
    
    # Convert group_ids to comma-separated GPU list
    local cuda_devices=""
    for (( i=0; i<${#group_ids}; i++ )); do
        local group_id="${group_ids:$i:1}"
        local start_gpu=$((group_id * 4))
        
        for j in {0..3}; do
            local gpu_id=$((start_gpu + j))
            if [ -z "$cuda_devices" ]; then
                cuda_devices="$gpu_id"
            else
                cuda_devices="$cuda_devices,$gpu_id"
            fi
        done
    done
    
    echo "Running with CUDA_VISIBLE_DEVICES=$cuda_devices $*"
    CUDA_VISIBLE_DEVICES="$cuda_devices" "$@"
}

verbose_warmup() {
    if [ $# -eq 0 ]; then
        echo "Usage: verbose_warmup <command>"
        echo "Example: verbose_warmup 'python train.py'"
        echo "         verbose_warmup 'nvidia-smi'"
        return 1
    fi
    
    # Create date-based directory under $HOME
    local dump_dir="$HOME/dleol_dump_$(date +%Y%m%d)/"
    mkdir -p "$dump_dir"
    
    echo "Running with verbose warmup settings: $*"
    echo "DLEOL_DUMP_PATH set to: $dump_dir"
    DLEOL_MISC_INFO=1 DLEOL_ENABLE_JIT_INFO=1 DLEOL_DUMP_CU=_ DLEOL_DUMP_PATH="$dump_dir" "$@"
}

tag_um() {
    git fetch origin master dev
    local excludes=(. ':!torch-2.5' ':!torch-2.7' ':!whl/check_dependencies.py')
    if [ -z "$1" ]; then
        git diff origin/master..origin/dev --stat -- "${excludes[@]}"
    else
        git diff origin/master..origin/dev -- "${excludes[@]}"
    fi
}