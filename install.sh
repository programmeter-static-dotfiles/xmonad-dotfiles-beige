#!/bin/bash

# THIS SCRIPT IS NOT JUST FOR INSTALLING MY XMONAD THEME!!!
# IT ALSO INSTALLS PACKAGES WHICH YOU PROBABLY DON'T NEED,
# AND THEY MIGHT EVEN BREAK YOUR SYSTEM
# IT IS FOR MY PERSONAL USE ONLY
# DO NOT RUN THIS SCRIPT

# Set up variables
read -p "[!] Enter username: " username
read -p "Install Nvidia drivers? [y/n]: " nvidia_prompt
while [[ "$nvidia_prompt" != "y" && "$nvidia_prompt" != "Y" && "$nvidia_prompt" != "n" && "$nvidia_prompt" != "y" && "$nvidia_prompt" != "N" ]]
do	
	echo "Please select y/n"
	read -p "Install Nvidia drivers? [y/n]: " nvidia_prompt
done
home_dir='/home/'"$username"
script_dir=$(dirname $(realpath $0))

# Update LightDM to match given username
sed -i 's/defaultuser/'"$username"'/g' "$script_dir"/lightdm.conf
sed -i 's/defaultuser/'"$username"'/g' "$script_dir"/.config/xmobarrc

# Add additional repositories
apt install software-properties-common -y
apt-add-repository non-free -y
apt-add-repository contrib -y
dpkg --add-architecture i386

# Get Enpass repo key
echo "deb https://apt.enpass.io/ stable main" > \
  /etc/apt/sources.list.d/enpass.list
wget -O - https://apt.enpass.io/keys/enpass-linux.key | tee /etc/apt/trusted.gpg.d/enpass.asc
apt update

# Download necessary .debs
wget https://launcher.mojang.com/download/Minecraft.deb

# Install all packages
if [[ "$nvidia_prompt" == "y" || "$nvidia_prompt" == "Y" ]]; then
	apt install nvidia-driver nvidia-settings nvidia-driver-libs:i386 -y
fi
apt install xorg pulseaudio alsa-utils xmonad libghc-xmonad-contrib-dev libghc-xmonad-dev xmobar i3lock steam gimp inkscape xfce4-settings yaru-theme-gtk thunderbird firefox-esr alacritty thunar vim git unzip shotwell celluloid gvfs-backends samba cifs-utils smbclient rofi kbdd lightdm feh picom xinput maim xclip xdotool libsdl2-2.0-0 libsdl2-dev libsdl2-image-2.0-0 libsdl2-image-dev libsdl2-ttf-2.0-0 libsdl2-ttf-dev libsdl2-mixer-2.0-0 libsdl2-mixer-dev gtk2-engines-murrine gtk2-engines-pixbuf rhythmbox xautolock htop libavcodec-extra playerctl gnome-disk-utility gufw enpass libreoffice-calc libreoffice-writer libreoffice-gtk3 printer-driver-hpcups hplip gamemode openvpn openssl openresolv transmission-gtk rsync timeshift pavucontrol gdb flatpak galculator mousepad python3.11-venv thunar-archive-plugin neovim ./Minecraft.deb -y
apt install --no-install-recommends xfce4-session -y
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install com.discordapp.Discord io.github.shiftey.Desktop com.vscodium.codium -y
apt autoremove dmenu -y

# Copy all configurations
cp -r "$script_dir"/.config/ "$home_dir"
cp -r "$script_dir"/.scripts/ "$home_dir"
cp -r "$script_dir"/.xmonad/ "$home_dir"
cp -r "$script_dir"/.local/ "$home_dir"
cp -r "$home_dir"/.local/share/themes/* /usr/share/themes/
cp -r "$home_dir"/.local/share/icons/* /usr/share/icons/
cp "$script_dir"/.bashrc "$home_dir"/
cp "$script_dir"/.vimrc "$home_dir"/
cp "$script_dir"/lightdm.conf /etc/lightdm/
mkdir -p "$home_dir"/Pictures/screenshots

# Set flatpak theme
flatpak override --filesystem=xdg-data/themes
flatpak override --filesystem=xdg-data/icons
flatpak override --env=GTK_THEME=Yaru-Amber-dark
flatpak override --env=ICON_THEME=Papirus-Dark

# Set theme with xfce settings
xfconf-query -c xsettings -p /Net/ThemeName -s "Yaru-Amber-dark"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark"

chown -R "$username":"$username" "$home_dir"

xdg-settings set default-web-browser firefox.desktop
xdg-mime default thunar.desktop inode/directory

systemctl set-default graphical.target

echo "Don't forget to copy VPN files to /etc/openvpn"
echo "Set up Timeshift and set rsync destination in ~/.xmonad/xmonad.hs"
echo "Set GTK theme, icon theme and font in lxappearancelxsession"
echo "Reboot your computer to apply the changes!"
