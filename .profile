export PATH=$PATH:$HOME/bin:$HOME/.local/bin

export EDITOR="nvim"
export TERMINAL="terminal"
export BROWSER="browser"
export SHELL="/usr/bin/zsh"
#export SHELL="/usr/bin/bash"
export MANPAGER='nvim +Man!'

alias sudo='sudo ' # Let sudo use aliases
alias vim="nvim"
alias ls="eza -a"
alias lsn="eza -a -l --sort modified --reverse"
alias top="htop"
alias pacman="pacman --color always"
alias yay="yay --color always"
alias config='git --git-dir=$HOME/src/bare-configs.git --work-tree=$HOME'
alias tree='tree -C -a'
alias sxiv='sxiv -a'
alias mpv='mpv --force-window=immediate --ytdl-raw-options=throttled-rate=100K --ytdl-format=135+bestaudio/best'
alias tf='tofu'

export GLOBIGNORE=".:.."

export TERMINFO=/usr/share/terminfo

export GTK_THEME=Adwaita:dark
export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
#export QT_STYLE_OVERRIDE=adwaita-dark
# TODO: plasma-workspace, lookandfeeltool -a breezedark

export DEBUGINFOD_URLS="https://debuginfod.archlinux.org"

export PATH=$PATH:~/bin/openapitools/

#source /usr/share/nvm/init-nvm.sh

if [[ "$(tty)" = "/dev/tty1" ]]; then
	startx
fi
