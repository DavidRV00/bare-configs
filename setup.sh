#!/bin/sh

# TODO:
#		- try it out once as-is
#		- passwords
#		- manual setups
#		- audio
#		- configs + customization:
#   	- refresh on bare repos
#   	- decide on github vs gitlab vs vps or whatever
#  		- figure out about diffs+patch (+git possibly)
#   	- get all current configs into bare repo
#   	- sync bare repo with remote
#  		- make setup.sh set up bare repo and sync from remote
#  			- (after this, we can modify configs independently from setup script)

set -euxo pipefail

alias sudo="sudo "
alias pacman="pacman --noconfirm"

mkdir -p $HOME/src

# TODO: Identify and interactively mount storage

sudo pacman -S sed git

# Passwords
# TODO:
# ---------------
#	-delete current gnupg and password-store
# 	-copy gnupg folder, export pub
#	-delete gnupg
#	-fresh gpg2 init
#	-import the secret + pub
#	-trust the key, ultimately
#	-clone password-store
#	-make a new password
#	-push
# ---------------
# set up gpg key pair
# import private + public key associated with password-store
# copy passgit private ssh key
# GIT_SSH_COMMAND="ssh -i ~/.ssh/passgit -F /dev/null" git clone ssh://git@davidv.xyz:/home/git/pass-repo ~/.password-store

# Retrieve configs + scripts / interfaces
# TODO: git bare repo stuff?
# TODO: get .profile and .xinitrc from version control
# TODO: set zsh as login; source .profile in .zshrc
# TODO: set .config/fontconfig/fonts.conf

# Set up package settings
sudo pacman -S artix-archlinux-support

# TODO: Put pacman.conf patch in version control
sudo cp /etc/pacman.conf pacman.conf-bkp
sudo cp pacman.conf-sample /etc/pacman.conf
sudo pacman-key --populate archlinux

# TODO: Put makepkg.conf patch in version control
sudo cp /etc/makepkg.conf makepkg.conf-bkp
sudo cp makepkg.conf-sample /etc/makepkg.conf

sudo pacman -Syu

# Install arch/artix packages
# TODO: Version control the package list and fetch it dynamically
cat pacman-pkgs.txt | sed 's/^#.*//g' | sed '/^$/d' | sudo pacman -S -

# Install yay
sudo pacman -S base-devel
cd $HOME/src
rm -rf yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay
cd $HOME

# Install AUR packages
# TODO: Version control the package list and fetch it dynamically
cat aur-pkgs.txt | sed 's/^#.*//g' | sed '/^$/d' | yay -S -

sudo rm pacman.conf-bkp
sudo rm makepkg.conf-bkp

# Retrieve source-based tools (dwm, dmenu, etc)
cd $HOME/src

git clone https://github.com/DavidRV00/dwm-fork
cd dwm-fork
sudo make install

# Pull in templates and special data and stuff

# TODO
# Perform manual setups (starship, conda (+packages), plex, mutt-wizard, rss-bridge, vundle + vim plugin-install + netrw, powerline fonts, data syncing, passwords, etc)
# echo "[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh" >> ~/.bashrc
# mw -a david@davidv.xyz
# mail sync

# Set up audio
# TODO: user into realtime, audio
# TODO: pull /etc/security/limits.conf
# TODO: set up jack+pulseaudio OR(/and/or?) pipewire
# TODO: get pajackconnect, set up .jackdrc, set up .xinitrc
# TODO: jack + midi: (https://manual.ardour.org/setting-up-your-system/setting-up-midi/midi-on-linux/)
	# a2jmidid -e

# TODO: automatically track new packages installed, to see if we want to add them to setup?
# TODO: same for conda

# Set up runit autostarts
# TODO: loop this
sudo ln -s /etc/runit/sv/bluetoothd /run/runit/service/
sudo ln -s /etc/runit/sv/cronie /run/runit/service/
sudo ln -s /etc/runit/sv/ntpd /run/runit/service/
sudo ln -s /etc/runit/sv/wpa_supplicant /run/runit/service/

# TODO: set up cron jobs

# TODO: interactively set up displays + wallpaper

