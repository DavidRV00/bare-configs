#!/bin/sh

# TODO:
#		- dmenu (/ other source-based)
#   - passwords
#   - manual setups
#   - audio
#		- displays, wallpapers
#		- get configs more in-order
#			- maintain branches: base, custom(/branches per computer)
#		- reinstall laptop

# TODO: pipeline installations so the rest of the steps don't wait on non-essential packages

set -x

alias sudo="sudo "
alias pacman="pacman --noconfirm"
alias makepkg="makepkg --noconfirm"
alias yay="yay --noconfirm"

srcdir="$(pwd)"

mkdir -p $HOME/src

sudo pacman -Sy sed grep awk fzf git artools-base

# Interactively mount drives
set +x
get_part() {
	prompt="$1"
	part="$(lsblk -n --list | grep "^...[0-9]\+.*" | fzf --prompt="$prompt" | awk '{print $1}')"
	echo "$part"
}

while true; do
	part=$( get_part "Select a partition to mount (esc to stop): " )
	[ "$part" != "" ] || break

	echo "Enter mount location for $part: "
	read loc

	set -x
	mkdir -p "$loc"
	mount /dev/"$part" "$loc"
	set +x
	sleep 0.5
	clear
done

lsblk
echo

echo "Writing to fstab:"
sudo fstabgen -U / | tee /etc/fstab

set -euxo pipefail

# Passwords
# TODO:
# ---------------
# -delete current gnupg and password-store
# -copy gnupg folder, export pub
# -delete gnupg
# -fresh gpg2 init
# -import the secret + pub
# -trust the key, ultimately
# -clone password-store
# -make a new password
# -push
# ---------------
# set up gpg key pair
# import private + public key associated with password-store
# copy passgit private ssh key
# GIT_SSH_COMMAND="ssh -i ~/.ssh/passgit -F /dev/null" git clone ssh://git@davidv.xyz:/home/git/pass-repo ~/.password-store

# Set up package settings
sudo pacman -S artix-archlinux-support

# TODO: Put pacman.conf patch in version control
cd "$srcdir"
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
cd $srcdir

# Install AUR packages
# TODO: Version control the package list and fetch it dynamically
cat aur-pkgs.txt | sed 's/^#.*//g' | sed '/^$/d' | yay -S -

sudo rm pacman.conf-bkp
sudo rm makepkg.conf-bkp

# Retrieve source-based tools
cd $HOME/src

git clone https://github.com/DavidRV00/dwm-fork
cd dwm-fork
make
sudo make install

# Retrieve configs + scripts / interfaces
cd $HOME/src
git clone --bare https://github.com/davidrv00/bare-configs.git

alias config='git --git-dir=$HOME/src/bare-configs.git --work-tree=$HOME'
config config --local status.showUntrackedFiles no
config restore --staged $HOME
config restore $HOME

# TODO: Don't do it like this
echo "alias config='git --git-dir=$HOME/src/bare-configs.git --work-tree=$HOME'" >> ~/.zshrc

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

# Pull in templates and special data and stuff

# TODO: automatically track new packages installed, to see if we want to add them to setup?
# TODO: same for conda

# Set up runit autostarts
set +x
for svc in bluetoothd cronie ntpd wpa_supplicant; do
	set -x
	sudo ln -s /etc/runit/sv/"$svc" /run/runit/service/
	set +x
done

# TODO: set up cron jobs

# TODO: interactively set up displays + wallpaper

