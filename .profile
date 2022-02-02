export PATH=$PATH:$HOME/bin
export EDITOR="nvim"
export TERMINAL="terminal"
export BROWSER="browser"
export SHELL="zsh"

alias vim="nvim"
alias ls="exa -a"
alias top="htop"
alias pacman="pacman --color always"
alias yay="yay --color always"
alias config='git --git-dir=$HOME/src/bare-configs.git --work-tree=$HOME'
alias tree='tree -C'

export TERMINFO=/usr/share/terminfo

# startx automatically
if [[ "$(tty)" = "/dev/tty1" ]]; then
	startx
fi
