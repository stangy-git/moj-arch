#!/usr/bin/env bash
set -e

echo " Installing my Arch setup"

# check if arch
if ! command -v pacman &>/dev/null; then
  echo "Not Arch Linux!"
  exit 1
fi


# dotfiles
cp -r dotfiles/* ~/

#turns on 32bit library for steam etc.
sudo sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf
#full sys upgrade
sudo pacman -Syu --noconfirm


# base packages
sudo pacman -S --noconfirm $(cat packages/base.txt)

# user apps
sudo pacman -S --noconfirm $(cat packages/apps.txt)




# flathub repo
if ! flatpak remote-list | grep -q flathub; then
  sudo flatpak remote-add --if-not-exists flathub \
    https://flathub.org/repo/flathub.flatpakrepo
fi

# install flatpak apps
xargs -a packages/flatpak.txt -r sudo flatpak install -y flathub


#aur
if ! command -v yay &>/dev/null; then
  sudo pacman -S --needed --noconfirm base-devel git
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
fi

# aur packages
yay -S --noconfirm $(cat packages/aur.txt)


# services
#./services.sh



# permissions
chmod +x dotfiles/bin/*


#ignore function of power button
sudo sed -i 's/^#HandlePowerKey=.*/HandlePowerKey=ignore/' /etc/systemd/logind.conf
sudo reboot

