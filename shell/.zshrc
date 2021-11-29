fpath=($fpath "/home/jhilker/.zfunctions")
setopt autocd
bindkey -v
# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_CHAR_SYMBOL="$ "
SPACESHIP_PROMPT_ORDER=(
   vi_mode 
   dir
   git
   char)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
