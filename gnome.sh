#!/bin/bash

sudo timedatectl set-ntp true
sudo hwclock --systohc

ISO=$(curl -4 ifconfig.co/country-iso)
sudo reflector -a 48 -c ${ISO} -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syy

sudo firewall-cmd --add-port=1025-65535/tcp --permanent
sudo firewall-cmd --add-port=1025-65535/udp --permanent
sudo firewall-cmd --reload

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
  'pipewire'
  'pipepwire-pulse'
  'pipewire-jack'
  'bluez'
  'bluez-utils'
  'cups'
  'hlip'
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
)

for PKG in "${PKGS[@]}"; do
  echo "Installing: ${PKG}"
  paru -S "$PKG" --noconfirm --needed
done

PKGS=(
  'epiphany' 
  'gnome-software'
)

for PKG in "${PKGS[@]}"; do
  echo "Uninstalling: ${PKG}"
  paru -Rcns "$PKG" --noconfirm
done

sudo systemctl enable gdm

