export PATH=$PATH:$HOME/bin
export EDITOR="nvim"
export TERMINAL="terminal"
export BROWSER="browser"
export SHELL="zsh"

export TERMINFO=/usr/share/terminfo

# startx automatically
if [[ "$(tty)" = "/dev/tty1" ]]; then
	startx
fi
