"""
Autoarch python script version 1.0.3

Changes in 1.0.3:
* Made things more simple overall
* Merged unnecessary functions into a single one
"""

# Import libraries
import subprocess
import time
import os

# Welcome message
print("""
┌────────────────────────────────────────────────┐
│    _         _             _             _     │
│   / \  _   _| |_ ___      / \   _ __ ___| |__  │
│  / _ \| | | | __/ _ \    / _ \ | '__/ __| '_ \ │
│ / ___ \ |_| | || (_) |  / ___ \| | | (__| | | |│
│/_/   \_\__,_|\__\___/  /_/   \_\_|  \___|_| |_|│
│                                                │
└────────────────────────────────────────────────┘
Version 1.0.3                  Made by markprower
""")

# Information gathering
s_language = input("Choose a language: [Ex.: pt_BR, en_US...]: ")
s_hostname = input("Choose a hostname: ")
s_username = input("Now a username: ")
s_language_local = s_language + ".UTF-8 UTF-8"
s_language_lang = "LANG=" + s_language + ".UTF-8"

# System type selection
def systype():
    systype.type = input("Is your system UEFI or BIOS? [U / B]: ")
    if systype.type == str("U") or systype.type == str("u"):
        print('')
        confirm = input("You have selected UEFI, correct? [Y / N]: ")
        if confirm == str("Y") or confirm == str("y"):
            disk_select()
            disk_setup()
            base_install()
            grub_install()
            desk_env()
            unmount()
            exit_text()
        elif confirm == str("N") or confirm == str("n"):
            print('')
            print("Understood. Try again.\n")
            systype()
        else:
            print('')
            print("Invalid input. Try again.\n")
            systype()
    elif systype.type == str("B") or systype.type == str("b"):
        print('')
        confirm = input("You have selected BIOS, correct? [Y / N]: ")
        if confirm == str("Y") or confirm == str("y"):
            disk_select()
            disk_setup()
            base_install()
            grub_install()
            desk_env()
            unmount()
            exit_text()
        elif confirm == str("N") or confirm == str("n"):
            print('')
            print("Understood. Try again.\n")
            systype()
        else:
            print('')
            print("Invalid input. Try again.\n")
            systype()
    else:
        print('')
        print("Invalid input. Try again.\n")
        systype()

# Disk selection
def disk_select():
    print('')
    print("Please select the disk that should be used:\n")
    os.system("lsblk")
    print('')
    disk_select.disk = input("Select the disk: [Ex.: sda, vda, nvme0n1...]: ")
    print('')
    print("The selected disk is", disk_select.disk, end=".\n")
    confirm = input("Is that correct? [Y / N]: ")
    print('')
    if confirm == str("Y") or confirm == str("y"):
        disk_select.dev = "/dev/{}".format(disk_select.disk)
        disk_select.bios_root = disk_select.dev + "1"
        disk_select.uefi_boot = disk_select.dev + "1"
        disk_select.uefi_swap = disk_select.dev + "2"
        disk_select.uefi_root = disk_select.dev + "3"
        print("Understood. The installation will begin in 10-seconds using", disk_select.disk, end=".\n")
        print("During this time, you can abort the installation by pressing 'Ctrl + C'.")
        print('')
        time_left = 10
        while time_left <= 10:
            print("Time left:", time_left)
            time.sleep(1)
            time_left -= 1
            if time_left == 0:
                break
    elif confirm == str("N") or confirm == str("n"):
        print("Understood. Try again.\n")
        disk_select()
    else:
        print("Invalid input. Try again.\n")
        disk_select()

# Disk setup
def disk_setup():
    if systype.type == str("U") or systype.type == str("u"):
        print("Creating GPT partition table...")
        subprocess.Popen(["parted", disk_select.dev, "mktable", "gpt", "-s"])
        time.sleep(1)
        print("Creating boot partition...")
        subprocess.Popen(["parted", disk_select.dev, "mkpart", "primary", "fat32", "0%", "256MiB", "-s"])
        time.sleep(1)
        print("Creating swap partition...")
        subprocess.Popen(["parted", disk_select.dev, "mkpart", "primary", "linux-swap", "256MiB", "8448MiB", "-s"])
        time.sleep(1)
        print("Creating root partition...")
        subprocess.Popen(["parted", disk_select.dev, "mkpart", "primary", "btrfs", "8448MiB", "100%", "-s"])
        time.sleep(1)
        print("Flagging boot partition as ESP...")
        subprocess.Popen(["parted", disk_select.dev, "set", "1", "esp", "on", "-s"])
        time.sleep(1)
        print("Formatting boot partition...")
        print('')
        subprocess.Popen(["mkfs.fat", "-F32", disk_select.uefi_boot])
        time.sleep(1)
        print("Formatting swap partition...")
        print('')
        subprocess.Popen(["mkswap", disk_select.uefi_swap])
        time.sleep(1)
        print("Formatting root partition...")
        print('')
        subprocess.Popen(["mkfs.btrfs", "-f", "-L", "System", disk_select.uefi_root])
        time.sleep(1)
        print('')
        print("Mounting filesystem...")
        subprocess.Popen(["mount", disk_select.uefi_root, "/mnt"])
        subprocess.Popen(["mount", disk_select.uefi_boot, "--mkdir", "/mnt/boot"])
        time.sleep(1)
        print("Disk setup complete.\n")
        time.sleep(3)
    elif systype.type == str("B") or systype.type == str("b"):
        print('')
        print("Creating MBR/DOS partition table...")
        subprocess.Popen(["parted", disk_select.dev, "mktable", "msdos", "-s"])
        time.sleep(1)
        print("Creating root partition...")
        subprocess.Popen(["parted", disk_select.dev, "mkpart", "primary", "btrfs", "0%", "100%", "-s"])
        time.sleep(1)
        print("Flagging root partition as bootable...")
        subprocess.Popen(["parted", disk_select.dev, "set", "1", "boot", "on", "-s"])
        time.sleep(1)
        print("Formatting root partition...")
        print('')
        subprocess.Popen(["mkfs.btrfs", "-f", "-L", "System", disk_select.bios_root])
        time.sleep(1)
        print('')
        print("Mounting filesystem...")
        subprocess.Popen(["mount", disk_select.bios_root, "/mnt"])
        time.sleep(1)
        print("Disk setup complete.\n")
        time.sleep(3)
    else:
        print('')
        print("Invalid disk type. Panick attack engaged.")
        exit()

# Base system installation & config
def base_install():
    print("The installation of the base system packages will begin shortly.\n")
    time.sleep(2)
    base_command = "pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware btrfs-progs dosfstools " \
                   "mtools exfatprogs f2fs-tools e2fsprogs jfsutils nilfs-utils reiserfsprogs udftools xfsprogs " \
                   "networkmanager network-manager-applet wpa_supplicant wireless_tools dialog nano man-db man-pages " \
                   "texinfo pipewire pipewire-pulse pipewire-alsa cups inetutils numlockx pkgfile fish git curl go " \
                   "grub efibootmgr os-prober fuse2 go "
    fstab_command = "genfstab -U /mnt >> /mnt/etc/fstab"
    s_language_local_command = "arch-chroot /mnt echo " + s_language_local + " >> " + "/mnt/etc/locale.gen"
    s_language_lang_command = "arch-chroot /mnt echo " + s_language_lang + " >> " + "/mnt/etc/locale.conf"
    s_hostname_command = "arch-chroot /mnt echo " + s_hostname + " >> " + "/mnt/etc/hostname"
    s_username_command = "arch-chroot /mnt useradd -mG wheel " + s_username
    s_network_autostart_command = "arch-chroot /mnt systemctl enable NetworkManager"
    s_cups_autostart_command = "arch-chroot /mnt systemctl enable cups"
    s_root_pass_command = "arch-chroot /mnt passwd"
    s_user_pass_command = "arch-chroot /mnt passwd " + s_username
    s_local_gen_command = "arch-chroot /mnt locale-gen"
    os.system(base_command)
    print('')
    print("Generating filesystem table...")
    time.sleep(1)
    os.system(fstab_command)
    print("Setting language...\n")
    time.sleep(1)
    os.system(s_language_local_command)
    os.system(s_language_lang_command)
    os.system(s_local_gen_command)
    print('')
    print("Setting hostname...")
    time.sleep(1)
    os.system(s_hostname_command)
    print("Creating user...")
    time.sleep(1)
    os.system(s_username_command)
    print("Configuring autostarting programs...")
    print('')
    time.sleep(1)
    os.system(s_network_autostart_command)
    os.system(s_cups_autostart_command)
    print('')
    print("Choose a password for root...\n")
    os.system(s_root_pass_command)
    print('')
    print("And now for the normal user...\n")
    os.system(s_user_pass_command)
    time.sleep(1)
    print('')
    print("Base system installed and configured.")

# Bootloader installation & config
def grub_install():
    uefi_inst_command = "arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB"
    uefi_config_blank_command = "arch-chroot /mnt echo ' ' >> /mnt/etc/default/grub"
    uefi_config_os_prober_command = "arch-chroot /mnt echo 'GRUB_DISABLE_OS_PROBER=false' >> /mnt/etc/default/grub"
    uefi_mkconfig_command = "arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg"
    bios_inst_command = "arch-chroot /mnt grub-install --target=i386-pc " + disk_select.dev
    bios_config_blank_command = "arch-chroot /mnt echo ' ' >> /mnt/etc/default/grub"
    bios_config_os_prober_command = "arch-chroot /mnt echo 'GRUB_DISABLE_OS_PROBER=false' >> /mnt/etc/default/grub"
    bios_mkconfig_command = "arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg"
    if systype.type == str("U") or systype.type == str("u"):
        print('')
        print("Installing grub bootloader...\n")
        os.system(uefi_inst_command)
        time.sleep(1)
        print('')
        print("Configuring grub bootloader...\n")
        os.system(uefi_config_blank_command)
        os.system(uefi_config_os_prober_command)
        os.system(uefi_mkconfig_command)
        time.sleep(1)
    elif systype.type == str("B") or systype.type == str("b"):
        print('')
        print("Installing grub bootloader...\n")
        os.system(bios_inst_command)
        time.sleep(1)
        print('')
        print("Configuring grub bootloader...\n")
        os.system(bios_config_blank_command)
        os.system(bios_config_os_prober_command)
        os.system(bios_mkconfig_command)
        time.sleep(1)
    else:
        print('')
        print("Invalid disk type. Panick attack engaged.")
        exit()

# Ask user if they want a desktop environment
def desk_env():
    print('')
    print("Would you like to install a desktop environment?")
    desktop_question = input("Type 'n' for none, 'k' for KDE, 'g' for GNOME or 'x' for XFCE: ")
    if desktop_question == str('N') or desktop_question == str('n'):
        print('')
        proceed = input("No desktop environment will be installed. Proceed? [Y / N]: ")
        if proceed == str("Y") or proceed == str("y"):
            print('')
            print("Understood.\n")
        elif proceed == str("N") or proceed == str("n"):
            print('')
            print("Understood, try again.\n")
            desk_env()
        else:
            print('')
            print("Invalid input, try again.\n")
            desk_env()
    elif desktop_question == str('K') or desktop_question == str('k'):
        print('')
        proceed = input("The KDE desktop environment will be installed. Proceed? [Y / N]: ")
        if proceed == str('Y') or proceed == str('y'):
            packages_command = "arch-chroot /mnt pacman -S xorg plasma console dolphin sddm kvantum-qt5 kcalc ark " \
                               "kate kvantum-qt5 kcolorchooser kaccounts-providers kaccounts-integration kio-gdrive " \
                               "dolphin-plugins gvfs gvfs-afc gvfc-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs " \
                               "gvfs-smb openssl sshfs kconfigwidgets kcoreaddons kdecoration kguiaddons kiconthemes " \
                               "kwindowsystem qt5-declarative qt5-x11extras qt5-tools qt5pas partitionmanager " \
                               "filelight kdialog ksysguard gnome-keyring libgnome-keyring kwalletmanager seahorse "
            services_command = "arch-chroot /mnt systemctl enable sddm"
            print('')
            print("Installing KDE...")
            os.system(packages_command)
            os.system(services_command)
            print('')
        elif proceed == str("N") or proceed == str("n"):
            print('')
            print("Understood, try again.\n")
            desk_env()
        else:
            print('')
            print("Invalid input, try again.\n")
            desk_env()
    elif desktop_question == str('G') or desktop_question == str('g'):
        print('')
        proceed = input("The GNOME desktop environment will be installed. Proceed? [Y / N]: ")
        if proceed == str('Y') or proceed == str('y'):
            packages_command = "arch-chroot /mnt pacman -S xorg gdm gnome gnome-extra gnome-tweaks " \
                               "nautilus-image-converter nautilus-sendto nautilus-share seahorse-nautilus file-roller "
            services_command = "arch-chroot /mnt systemctl enable gdm"
            print('')
            print("Installing GNOME...")
            os.system(packages_command)
            os.system(services_command)
            print('')
        elif proceed == str("N") or proceed == str("n"):
            print('')
            print("Understood, try again.\n")
            desk_env()
        else:
            print('')
            print("Invalid input, try again.\n")
            desk_env()
    elif desktop_question == str('X') or desktop_question == str('x'):
        print('')
        proceed = input("The XFCE desktop environment will be installed. Proceed? [Y / N]: ")
        if proceed == str('Y') or proceed == str('y'):
            pkg_command = "arch-chroot /mnt pacman -S xorg lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings " \
                          "gvfs gvfs-afc gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb menumaker " \
                          "mousepad ristretto thunar thunar-archive-plugin thunar-media-tags-plugin xarchiver " \
                          "thunar-volman xfce4 xfce4-goodies xfce4-clipman-plugin xfce4-whiskermenu-plugin " \
                          "xfce4-pulseaudio-plugin accountsservice gtk3 python-cairo python-gobject python-pexpect " \
                          "intltool python-distutils-extra cheese "
            svc_command = "arch-chroot /mnt systemctl enable lightdm"
            print('')
            print("Installing XFCE...")
            os.system(pkg_command)
            os.system(svc_command)
        elif proceed == str("N") or proceed == str("n"):
            print('')
            print("Understood, try again.\n")
            desk_env()
        else:
            print('')
            print("Invalid input, try again.\n")
            desk_env()
    else:
        print('')
        print("Invalid input, try again.\n")
        desk_env()

# Unmount partitions
def unmount():
    fs_umount_command = "umount -R /mnt"
    print('')
    print("Unmounting filesystem...")
    os.system(fs_umount_command)

# Exit message
def exit_text():
    print("""
########################################################################
My job is done, you can now reboot into your brand new operating system!
########################################################################
    """)
    exit()

systype()
