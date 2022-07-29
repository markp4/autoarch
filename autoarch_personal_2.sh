# Script 2, must be executed inside the freshly installed system as the normal user

# Set variables
export SUSERNAME="tails"

# Set config files
sudo mkdir /etc/libvirt && sudo cp dotfiles/libvirt.conf /etc/libvirt
sudo cp dotfiles/pacman.conf /etc && sudo pacman -Syy && sudo pkgfile --update

# Install personal pacman packages
sudo pacman -S --needed qbittorrent discord telegram-desktop audacious audacity mpv vlc obs-studio avidemux-qt kdenlive gimp krita kcalc ark kate plasma konsole dolphin sddm kvantum-qt5 kcolorchooser kaccounts-providers kaccounts-integration kio-gdrive dolphin-plugins gvfs gvfs-afc gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb openssl sshfs cmake libx11 libxrandr libxnvctrl dotnet-sdk-6.0 guvcview-qt gwenview android-file-transfer android-tools lutris steam steam-native-runtime gamemode xf86-input-wacom xf86-video-amdgpu mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon nvidia nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader vdpauinfo mesa-vdpau libvdpau-va-gl libvdpau libva-vdpau-driver lib32-mesa-vdpau lib32-libvdpau lib32-libva-vdpau-driver gstreamer-vaapi libva-utils libva-mesa-driver lib32-libva-mesa-driver easyeffects gst-plugin-pipewire lib32-pipewire dina-font tamsyn-font terminus-font ttf-bitstream-vera ttf-croscore ttf-dejavu ttf-droid gnu-free-fonts ttf-ibm-plex ttf-liberation ttf-linux-libertine noto-fonts ttf-roboto tex-gyre-fonts ttf-ubuntu-font-family ttf-anonymous-pro ttf-cascadia-code ttf-fantasque-sans-mono otf-fantasque-sans-mono ttf-fira-mono otf-fira-mono ttf-fira-code ttf-hack otf-hermit ttf-inconsolata ttc-iosevka ttf-jetbrains-mono ttf-monofur adobe-source-code-pro-fonts cantarell-fonts inter-font ttf-opensans adobe-source-sans-fonts gentium-plus-font ttf-junicode noto-fonts-cjk ttf-khmer ttf-tibetan-machine noto-fonts-emoji ttf-joypixels texlive-core texlive-fontsextra otf-latin-modern otf-latinmodern-math unrar unarchiver p7zip wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama libgcrypt lib32-libgcrypt ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs xorg atomicparsley python-pycryptodome meson ninja samba jre-openjdk flameshot ksysguard mlocate vim qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat ebtables iptables-nft numlockx neofetch catimg chafa youtube-dl bash-completion fwupd gnome-keyring libgnome-keyring kwalletmanager seahorse gcc-libs libnatpmp miniupnpc rust latte-dock zerotier-one sassc htop btop strace python-secretstorage python-gnupg gparted ntfs-3g gpart partitionmanager fatresize filelight kdialog winetricks libxss nss cups libnotify libwnck3 python-gobject python-pyxdg python-setuptools dbus gcc-libs glew glfw-x11 glslang lib32-dbus lib32-libglvnd nlohmann-json python-mako spdlog vulkan-headers lib32-gcc-libs lib32-libx11 qt5pas glxgears vulkan-tools cairo desktop-file-utils hicolor-icon-theme libappimage libbsd libxpm qt5-base shared-mime-info boost gtest qt5-tools curl gst-plugins-ugly gstreamer nspr libsecret libappindicator-gtk3 python-pypubsub python-wxpython xdg-utils ffmpeg fzf pacman-contrib extra-cmake-modules kconfigwidgets kcoreaddons kdecoration kguiaddons kiconthemes kwindowsystem qt5-declarative qt5-x11extras pyside6 python-requests qt6-tools python-build python-installer python-wheel imagemagick unzip lib32-gcc-libs lib32-libxext python-cachetools python-pycryptodomex python-six python-google-api-python-client python-mock python-protobuf python-pytest-cov python-vcrpy python-yaml python-gevent python-nose python-coverage nodejs jq npm go ttf-carlito pavucontrol cheese vkd3d lib32-vkd3d vulkan-mesa-layers lib32-vulkan-mesa-layers vulkan-validation-layers lib32-vulkan-validation-layers vulkan-extra-layers xf86-video-amdgpu ocl-icd lib32-ocl-icd

# Remove discover
sudo pacman -R --noconfirm discover

# Prepare for git and AUR hell
mkdir ~/Pacotes
cd ..

# Repository cloning hell
git clone --depth 1 https://github.com/vandalsoul/darkmatter-grub2-theme    # Fancy GRUB theme
git clone https://github.com/ishitatsuyuki/LatencyFleX.git                  # Nvidia Reflex
git clone https://gitlab.com/Scrumplex/vibrant.git                          # Color saturation changer
git clone https://gitlab.com/fzwoch/obs-nvfbc.git                           # Nvidia Frame Buffer Capture on OBS
git clone https://github.com/Keylase/nvidia-patch.git                       # Patches for crappy proprietary driver
git clone https://aur.archlinux.org/python-gevent-eventemitter.git          # Dependency of packages below
git clone https://aur.archlinux.org/nodejs-nativefier.git                   # Dependency of packages below
git clone https://aur.archlinux.org/python-vdf.git                          # Dependency of packages below
git clone https://aur.archlinux.org/python-inputs.git                       # Dependency of packages below
git clone https://aur.archlinux.org/python-polib.git                        # Dependency of packages below
git clone https://aur.archlinux.org/python-steam.git                        # Dependency of packages below
git clone https://aur.archlinux.org/lib32-libxnvctrl.git                    # Dependency of packages below
git clone https://aur.archlinux.org/brave-bin.git
git clone https://aur.archlinux.org/arronax.git
git clone https://aur.archlinux.org/mangohud.git
git clone https://aur.archlinux.org/goverlay-bin.git
git clone https://aur.archlinux.org/appimagelauncher.git
git clone https://aur.archlinux.org/onlyoffice-bin.git
git clone https://aur.archlinux.org/youtube-music-bin.git
git clone https://aur.archlinux.org/youtube-dl-gui-git.git
git clone https://aur.archlinux.org/downgrade.git
git clone https://aur.archlinux.org/lightly-qt.git
git clone https://aur.archlinux.org/protonup-qt.git
git clone https://aur.archlinux.org/whatsapp-nativefier.git
git clone https://aur.archlinux.org/yay-bin.git

# Build and install vibrant
cd vibrant
mkdir build && cd build
cmake .. && make
sudo cp vibrant-cli/vibrant-cli /usr/bin
sudo chmod +x /usr/bin/vibrant-cli
cd ~/Git

# Build and install obs-nvfbc
cd obs-nvfbc
meson build
ninja -C build
mkdir -p ~/.config/obs-studio/plugins/nvfbc/bin/64bit
cp build/nvfbc.so ~/.config/obs-studio/plugins/nvfbc/bin/64bit
cd ..

# Install darkmatter-grub-theme
cd darkmatter-grub2-theme
sudo python3 install.py Arch
cd ..

# AUR compiling hell
cd python-gevent-eventemitter && makepkg
cp *.pkg.tar.zst ~/Pacotes && sudo pacman -U *.pkg.tar.zst && cd ..

cd nodejs-nativefier && makepkg
cp *.pkg.tar.zst ~/Pacotes && sudo pacman -U *.pkg.tar.zst && cd ..

cd python-vdf && makepkg
cp *.pkg.tar.zst ~/Pacotes && sudo pacman -U *.pkg.tar.zst && cd ..

cd python-inputs && makepkg
cp *.pkg.tar.zst ~/Pacotes && sudo pacman -U *.pkg.tar.zst && cd ..

cd python-polib && makepkg
cp *.pkg.tar.zst ~/Pacotes && sudo pacman -U *.pkg.tar.zst && cd ..

cd python-steam && makepkg
cp *.pkg.tar.zst ~/Pacotes && sudo pacman -U *.pkg.tar.zst && cd ..

cd lib32-libxnvctrl && makepkg
cp *.pkg.tar.zst ~/Pacotes && sudo pacman -U *.pkg.tar.zst && cd ..

cd brave-bin && makepkg
cp *.pkg.tar.zst ~/Pacotes && sudo pacman -U *.pkg.tar.zst && cd ..

cd arronax && makepkg
cp *.pkg.tar.zst ~/Pacotes && sudo pacman -U *.pkg.tar.zst && cd ..

cd mangohud && makepkg
cp *.pkg.tar.zst ~/Pacotes && sudo pacman -U *.pkg.tar.zst && cd ..

cd goverlay-bin && makepkg
cp *.pkg.tar.zst ~/Pacotes && sudo pacman -U *.pkg.tar.zst && cd ..

cd appimagelauncher && makepkg
cp *.pkg.tar.zst ~/Pacotes && sudo pacman -U *.pkg.tar.zst && cd ..

cd onlyoffice-bin && makepkg
cp *.pkg.tar.zst ~/Pacotes && sudo pacman -U *.pkg.tar.zst && cd ..

cd youtube-music-bin && makepkg
cp *.pkg.tar.zst ~/Pacotes && sudo pacman -U *.pkg.tar.zst && cd ..

cd youtube-dl-gui-git && makepkg
cp *.pkg.tar.zst ~/Pacotes && sudo pacman -U *.pkg.tar.zst && cd ..

cd downgrade && makepkg
cp *.pkg.tar.zst ~/Pacotes && sudo pacman -U *.pkg.tar.zst && cd ..

cd lightly-qt && makepkg
cp *.pkg.tar.zst ~/Pacotes && sudo pacman -U *.pkg.tar.zst && cd ..

cd protonup-qt && makepkg
cp *.pkg.tar.zst ~/Pacotes && sudo pacman -U *.pkg.tar.zst && cd ..

cd whatsapp-nativefier && makepkg
cp *.pkg.tar.zst ~/Pacotes && sudo pacman -U *.pkg.tar.zst && cd ..

cd yay-bin && makepkg
cp *.pkg.tar.zst ~/Pacotes && sudo pacman -U *.pkg.tar.zst && cd ~

# VM Support setup
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
sudo gpasswd -a $SUSERNAME libvirt
sudo virsh net-define --file /etc/libvirt/qemu/networks/default.xml
sudo virsh net-autostart --network default
sudo systemctl restart libvirtd

# Autostarting
sudo systemctl enable sddm
sudo systemctl enable zerotier-one
gnome-keyring-daemon --start
sudo gnome-keyring-daemon --start   # Idk if using sudo makes any difference but it's here anyway lmao

# Change default shell to fish
chsh -s /bin/fish $SUSERNAME
sudo chsh -s /bin/fish root

# Install tails ASCII art
mkdir ASCII
cp ~/Git/autoarch/dotfiles/tails ASCII

# Run neofetch to generate the default config file
neofetch

# Install custom neofetch config file
cp ~/Git/autoarch/dotfiles/config.conf ~/.config/neofetch
