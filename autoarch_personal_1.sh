# Script 1, must be executed inside the live USB environment

# Set locale and language variables
export LOCALE_EN="en_US.UTF-8 UTF-8"
export LOCALE_PT="pt_BR.UTF-8 UTF-8"
export SLANGUAGE="LANG=pt_BR.UTF-8"
export SKBLAYOUT="KEYMAP=us"

# Set network variables
export SHOSTNAME="tornado"
export HOSTSET1="127.0.0.1 localhost"
export HOSTSET2="::1 localhost"
export HOSTSET3="127.0.1.1 tornado.localdomain tornado"

# Set user variable
export SUSERNAME="tails"

# Disk setup
parted /dev/nvme0n1 mktable gpt -s
parted /dev/nvme0n1 mkpart primary fat32 0% 256MiB -s
parted /dev/nvme0n1 mkpart primary linux-swap 256MiB 8448MiB -s
parted /dev/nvme0n1 mkpart primary btrfs 8448MiB 100% -s
parted /dev/nvme0n1 set 1 esp on -s
mkfs.fat -F32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
mkfs.btrfs -f -L Sistema /dev/nvme0n1p3
parted /dev/sda mktable gpt -s
parted /dev/sda mkpart btrfs 0% 100% -s
mkfs.btrfs -f -L Dados /dev/sda1
mount /dev/nvme0n1p3 /mnt
mount --mkdir /dev/nvme0n1p1 /mnt/boot
mount --mkdir /dev/sda1 /mnt/home

# Update pacman config for live environment
cp dotfiles/pacman.conf /etc
pacman -Syy

# Base system installation
pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware btrfs-progs dosfstools mtools exfatprogs f2fs-tools e2fsprogs jfsutils nilfs-utils reiserfsprogs udftools xfsprogs networkmanager network-manager-applet wpa_supplicant wireless_tools dialog nano man-db man-pages texinfo pipewire pipewire-pulse pipewire-alsa cups inetutils numlockx pkgfile fish git curl go grub efibootmgr os-prober fuse2 go ntfs-3g

# FStab generation
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot
arch-chroot /mnt echo $LOCALE_EN >> /mnt/etc/locale.gen
arch-chroot /mnt echo $LOCALE_PT >> /mnt/etc/locale.gen
arch-chroot /mnt echo $SLANGUAGE >> /mnt/etc/locale.conf
arch-chroot /mnt echo $SKBLAYOUT >> /mnt/etc/vconsole.conf
arch-chroot /mnt locale-gen

arch-chroot /mnt echo $SHOSTNAME >> /mnt/etc/hostname
arch-chroot /mnt echo $HOSTSET1 >> /mnt/etc/hosts
arch-chroot /mnt echo $HOSTSET2 >> /mnt/etc/hosts
arch-chroot /mnt echo $HOSTSET3 >> /mnt/etc/hosts

arch-chroot /mnt echo " " >> /mnt/etc/sudoers
arch-chroot /mnt echo "%wheel ALL=(ALL:ALL) ALL" >> /mnt/etc/sudoers
arch-chroot /mnt useradd -mG wheel $SUSERNAME
arch-chroot /mnt chown $SUSERNAME:$SUSERNAME /games
arch-chroot /mnt passwd $SUSERNAME
arch-chroot /mnt passwd

arch-chroot /mnt systemctl enable NetworkManager
arch-chroot /mnt systemctl enable cups

arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --recheck
arch-chroot /mnt echo " " >> /etc/default/grub
arch-chroot /mnt echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
