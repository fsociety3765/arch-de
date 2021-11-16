#!/bin/bash

echo "-------------------------------------------------"
echo "Starting setup                                   "
echo "-------------------------------------------------"
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
  'xorg'
  'gnome'
  'qgnomeplatform'
  'firefox'
  'brave-bin'
  'torbrowser-launcher'
  'onionshare'
  'bitwarden'
  'signal-desktop'
  'element-desktop'
  'discord'
  'gimp'
  'inkscape'
  'gnome-tweaks'
  'arc-gtk-theme'
  'arc-icon-theme'
  'papirus-icon-theme'
  'papirus-folders'
  'rpi-imager-bin'
  'terminator'
  'veracrypt'
  'kdenlive'
  'obs-studio'
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
  'networkmanager-openvpn'
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
  'ttf-ms-fonts'
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
  'popsicle-bin'
  'ipscan'
  'crossover'
  'android-file-transfer'
  'cockpit'
  'cockpit-machines'
  'packagekit'
  'duplicati2-beta'
  'gnome-connections'
  'gufw'
  'snapper-gui-git'
  'joplin-desktop-bin'
  'standardnotes-bin'
  'breeze-icons'
  'xcursor-breeze'
  'vscodium-bin'
  'authy'
  'transmission-gtk'
  'transmission-remote-gtk'
  'caffeine-ng'
  'gtkhash-git'
  'alacarte'
  'deja-dup'
  'yad'
  'loginized'
  'lollypop'
  'python-notify2'
  'python-psutils'
  'gnome-shell-extension-dash-to-dock'
  'gnome-shell-extension-dash-to-panel'
  'gnome-shell-extension-arc-menu'
  'gnome-shell-extension-desktop-icons-ng'
  'gnome-shell-extension-gnome-ui-tune-git'
  'gnome-shell-extension-just-perfection-desktop-git'
  'gnome-shell-extension-appindicator'
  'gnome-shell-extension-compiz-windows-effect-git'
  'gnome-shell-extension-blur-my-shell-git'
  'gnome-shell-extension-sound-output-device-chooser'
  'gnome-shell-extension-vitals-git'
  'gnome-shell-extension-gsconnect'
  'gnome-shell-extension-compiz-alike-magic-lamp-effect-git'
  'gnome-shell-extension-clipboard-indicator'
  'gnome-shell-extension-status-area-horizontal-spacing'
  'gnome-shell-extension-transparent-window-moving-git'
  'dropbox'
  'nautilus-dropbox'
  'figma-linux'
  'nextcloud-client'
  'zenmap'
  'gnome-usage'
  'gnome-nettool'
  'plymouth'
  'gdm-plymouth'
  'plymouth-theme-dark-arch'
)

for PKG in "${PKGS[@]}"; do
  echo "Installing: ${PKG}"
  paru -S "$PKG" --noconfirm --needed
done

if lspci | grep -E "NVIDIA|GeForce"; then
    paru -S nvidia nvidia-settings nvidia-utils --noconfirm --needed
    nvidia-xconfig
elif lspci | grep -E "Radeon"; then
    paru -S xf86-video-amdgpu --noconfirm --needed
elif lspci | grep -E "Integrated Graphics Controller"; then
    paru -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils --needed --noconfirm
elif lspci | grep -E "VMware SVGA II Adapter"; then
    IS_VM=true
    paru -S xf86-video-vmware xf86-input-vmmouse mesa --needed --noconfirm
fi

echo "-------------------------------------------------"
echo "Uinstalling bloat                                "
echo "-------------------------------------------------"
PKGS=(
  'epiphany' 
  'gnome-software'
  'gnome-music'
  'eog'
  'gnome-boxes'
)

for PKG in "${PKGS[@]}"; do
  echo "Uninstalling: ${PKG}"
  paru -Rcns "$PKG" --noconfirm
done

echo "-------------------------------------------------"
echo "Enabling services to run at boot  "
echo "-------------------------------------------------"
sudo systemctl enable gdm
sudo systemctl enable snapd
sudo systemctl enable cockpit
if [ IS_VM ]; then
  sudo systemctl enable vmtoolsd
fi

echo "-------------------------------------------------"
echo "Configuring the desktop environment              "
echo "-------------------------------------------------"
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Breeze'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
papirus-folders -C breeze --theme Papirus-Dark
gnome-extensions enable pop-shell@system76.com
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable drive-menu@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable apps-menu@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable dash-to-dock@micxgx.gmail.com
gnome-extensions enable ding@rastersoft.com
gnome-extensions enable gnome-ui-tune@itstime.tech
gnome-extensions enable just-perfection-desktop@just-perfection
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
gnome-extensions enable compiz-windows-effect@hermes83.github.com
gnome-extensions enable blur-my-shell@aunetx
gnome-extensions enable sound-output-device-chooser@kgshank.net
gnome-extensions enable gsconnect@andyholmes.github.io
gnome-extensions enable compiz-alike-magic-lamp-effect@hermes83.github.com
gnome-extensions enable pamac-updates@manjaro.org
gnome-extensions enable transparent-window-moving@noobsai.github.com
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/archlinux/simple.png
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'firefox.desktop', 'org.gnome.Calculator.desktop', 'org.gnome.Terminal.desktop', 'gnome-control-center.desktop']"
sudo sed -i "s/#EnableAUR/EnableAUR/g" /etc/pamac.conf
sudo sed -i "s/#CheckAURUpdates/CheckAURUpdates/g" /etc/pamac.conf
sudo sed -i "s/#NoUpdateHideIcon/NoUpdateHideIcon/g" /etc/pamac.conf
sudo sed -i "s/#RemoveUnrequiredDeps/RemoveUnrequiredDeps/g" /etc/pamac.conf
sudo sed -i "s/#KeepBuiltPkgs/KeepBuiltPkgs/g" /etc/pamac.conf
sudo echo "EnableFlatpak" >> /etc/pamac.conf
sudo echo "CheckFlatpakUpdates" >> /etc/pamac.conf
sudo echo "EnableSnap" >> /etc/pamac.conf
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface cursor-theme 'Breeze'
sudo ./set-gdm-wallpaper.sh --css "background-size: contain; background-color: #191919;" ./background.jpg
gsettings set org.gnome.desktop.app-folders folder-children "['Office', 'Accessories', 'System', 'Communication']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/System/ name "System Tools"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Office/ name "Office"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Accessories/ name "Accessories"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Communication/ name "Communication"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Office/ categories "['Office', 'Publishing']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/System/ categories "['System']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Accessories/ categories "['Utility']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Communication/ categories "['Instant Messaging', 'Chat']"

echo "-------------------------------------------------"
echo "Configuring AppArmor and Audit                   "
echo "-------------------------------------------------"
sudo groupadd -r audit
sudo gpasswd -a ${USER} audit

echo "-------------------------------------------------"
echo "Configuring audit log group                      "
echo "This must be run as the ROOT user                "
echo "Please enter the ROOT user password when prompted"
echo "-------------------------------------------------"
su - root -c 'echo "log_group = audit" >> /etc/audit/auditd.conf'
mkdir ~/.config/autostart
cat > ~/.config/autostart/apparmor-notify.desktop << EOF
[Desktop Entry]
Type=Application
Name=AppArmor Notify
Comment=Receive on screen notifications of AppArmor denials
TryExec=aa-notify
Exec=aa-notify -p -s 1 -w 60 -f /var/log/audit/audit.log
StartupNotify=false
NoDisplay=true
EOF

echo "-------------------------------------------------"
echo "Setting up ZSH plugins                           "
echo "-------------------------------------------------"
sed -i "s/plugins=(git)/plugins=(git z)/g" ~/.zshrc
echo "source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
echo "source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
echo "neofetch" >> ~/.zshrc

#echo "-------------------------------------------------"
#echo "Setting up Plymouth                              "
#echo "-------------------------------------------------"
#sudo sed -i "s/MODULES=(/MODULES=(i915 /g" /etc/mkinitcpio.conf
#sudo sed -i "s/base udev autodetect modconf/base udev plymouth autodetect modconf/g" /etc/mkinitcpio.conf
#sudo plymouth-set-default-theme -R spinner
#sudo sed -i 's|GRUB_CMDLINE_LINUX_DEFAULT="|GRUB_CMDLINE_LINUX_DEFAULT="quiet splash rd.udev.log_priority=3 vt.global_cursor_default=0 |g' /etc/default/grub
#sudo update-grub

echo "-------------------------------------------------"
echo "Complete                                         "
echo "Rebooting in 5 seconds...                        "
echo "Press CTRL+C to cancel the reboot                "
echo "-------------------------------------------------"
echo "Rebooting in 5 Seconds ..." && sleep 1
echo "Rebooting in 4 Seconds ..." && sleep 1
echo "Rebooting in 3 Seconds ..." && sleep 1
echo "Rebooting in 2 Seconds ..." && sleep 1
echo "Rebooting in 1 Second ..." && sleep 1
sudo reboot now

