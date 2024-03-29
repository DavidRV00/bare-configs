#!/bin/sh

donefile="$HOME/.config/.initoncedone"
if [ -e "$donefile" ]; then
	exit
fi

# KDE theme
lookandfeeltool -a org.kde.breezedark.desktop &

# Setup reminders
terminal -e nvim "$HOME/.cache/setupreminder.md" &

touch "$donefile"
