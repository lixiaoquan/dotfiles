# Setup fzf
# ---------
if [[ ! "$PATH" == */home/xiaoquan.li/.fzf/bin* ]]; then
  export PATH="$PATH:/home/xiaoquan.li/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/xiaoquan.li/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/xiaoquan.li/.fzf/shell/key-bindings.bash"

