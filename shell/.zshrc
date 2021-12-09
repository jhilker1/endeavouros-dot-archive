fpath=($fpath "/home/jhilker/.zfunctions")
setopt autocd
bindkey -v

export PATH=~/.local/bin:~/.npm-global:$PATH
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(starship init zsh)"

export EDITOR=nvim
source ~/.aliases
# Added by zap installation script
PATH=$PATH:$HOME/.local/bin/
