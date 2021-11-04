#!/bin/bash

echo "-------------------------------------------------"
echo "Starting setup                                   "
echo "-------------------------------------------------"
sudo echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> "/etc/sudoers.d/${USER}"
sudo timedatectl set-ntp true
sudo hwclock --systohc
ISO=$(curl -4 ifconfig.co/country-iso)

echo "-------------------------------------------------"
echo "Setting up the best mirrors for ${ISO}           "
echo "-------------------------------------------------"
sudo reflector -a 48 -c ${ISO} -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syy

echo "-------------------------------------------------"
echo "Configuring firewall with sensible defaults      "
echo "-------------------------------------------------"
sudo firewall-cmd --add-port=1025-65535/tcp --permanent
sudo firewall-cmd --add-port=1025-65535/udp --permanent
sudo firewall-cmd --reload

echo "-------------------------------------------------"
echo "Installing desktop environment packages          "
echo "-------------------------------------------------"
PKGS=(
  'gdm' 
  'gnome'
  'firefox'
  'gimp'
  'gnome-tweaks'
  'arc-gtk-theme'
  'arc-icon-theme'
  'papirus-icon-theme'
  'vlc'
  'mpv'
  'celluloid'
  'gthumb'
  'gparted'
  'archlinux-wallpaper'
  'grub-customizer'
  'dconf-editor'
  'flatpak'
  'bluez'
  'bluez-utils'
  'cups'
  'hplip'
  'alsa-utils'
  'pipewire'
  'pipewire-alsa'
  'pipewire-pulse'
  'pipewire-jack'
  'dina-font'
  'tamsyn-font'
  'bdf-unifont'
  'ttf-bitstream-vera'
  'ttf-croscore'
  'ttf-dejavu'
  'ttf-droid'
  'gnu-free-fonts'
  'ttf-ibm-plex'
  'ttf-liberation'
  'ttf-linux-libertine'
  'noto-fonts'
  'ttf-roboto'
  'tex-gyre-fonts'
  'ttf-ubuntu-font-family'
  'ttf-anonymous-pro'
  'ttf-cascadia-code'
  'ttf-fantasque-sans-mono'
  'ttf-fira-mono'
  'ttf-hack'
  'ttf-fira-code'
  'ttf-inconsolata'
  'ttf-jetbrains-mono'
  'ttf-monofur'
  'adobe-source-code-pro-fonts'
  'cantarell-fonts'
  'inter-font'
  'ttf-opensans'
  'gentium-plus-font'
  'ttf-junicode'
  'adobe-source-han-sans-otc-fonts'
  'adobe-source-han-serif-otc-fonts'
  'noto-fonts-cjk'
  'noto-fonts-emoji'
  'chrome-gnome-shell'
  'snapd'
  'pamac-all'
  'onlyoffice-bin'
  'gnome-shell-extension-pop-shell-git'
  'etcher-bin'
  'gnome-connections'
  'gufw'
  'snapper-gui-git'
  'joplin-desktop'
  'standardnotes-bin'
  'breeze'
  'breeze-icons'
  'xcursor-breeze'
  'vscodium-bin'
  'authy'
  'transmission-gtk'
  'transmission-remote-gtk'
  'caffeine-ng'
  'gtkhash'
  'alacarte'
  'deja-dup'
  'yad'
  'loginized'
)

for PKG in "${PKGS[@]}"; do
  echo "Installing: ${PKG}"
  paru -S "$PKG" --noconfirm --needed
done

echo "-------------------------------------------------"
echo "Uinstalling boat                                 "
echo "-------------------------------------------------"
PKGS=(
  'epiphany' 
  'gnome-software'
)

for PKG in "${PKGS[@]}"; do
  echo "Uninstalling: ${PKG}"
  paru -Rcns "$PKG" --noconfirm
done

echo "-------------------------------------------------"
echo "Enabling display manager service to run at boot  "
echo "-------------------------------------------------"
sudo systemctl enable gdm

echo "-------------------------------------------------"
echo "Resetting user (${USER}) sudo permissions        "
echo "-------------------------------------------------"
sudo echo "${USER} ALL=(ALL) ALL" >> "/etc/sudoers.d/${USER}"

echo "-------------------------------------------------"
echo "Setup complete                                   "
echo "                                   "
echo "-------------------------------------------------"
