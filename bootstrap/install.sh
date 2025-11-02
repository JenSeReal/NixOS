#!/bin/sh

# Adapted from https://github.com/jbgreer/Nixfiles/blob/main/install.sh

configuration_url=https://raw.githubusercontent.com/JenSeReal/NixOS/main/bootstrap/configuration.nix
hardware_url=https://raw.githubusercontent.com/JenSeReal/NixOS/main/bootstrap/hardware-configuration.nix

read -p "Enter the hostname [nixos]: " hostname
hostname=${hostname:-"nixos"}

read -p "Enter the timezone [Europe/Berlin]: " timezone
timezone=${timezone:-"Europe/Berlin"}

read -p "Enter the default locale [en_US.UTF-8]: " default_locale
default_locale=${default_locale:-"en_US.UTF-8"}

read -p "Enter the extra locale [de_DE.UTF-8]: " extra_locale
extra_locale=${extra_locale:-"de_DE.UTF-8"}

read -p "Enter the default user [jfp]: " default_user
default_user=${default_user:-"jfp"}

read -p "Enter the xkb layout [de]: " xkb_layout
xkb_layout=${xkb_layout:-"de"}

read -p "Enter the xkb variant [nodeadkeys]: " xkb_variant
xkb_variant=${xkb_variant:-"nodeadkeys"}

read -p "Enter the xkb variant [caps:escape]: " xkb_options
xkb_options=${xkb_options:-"caps:escape"}

read -p "Enter the console keyboard layout [de-latin1-nodeadkeys]: " console_keyboard_layout
console_keyboard_layout=${console_keyboard_layout:-"de-latin1-nodeadkeys"}

read -p "Enter the disk name [/dev/nvme0n1]: " DISK
DISK=${DISK:-"/dev/nvme0n1"}

# parition root and boot
sudo parted $DISK -- mklabel gpt
sudo parted $DISK -- mkpart ROOTPART 512MB 100%
sudo parted $DISK -- mkpart ESPPART fat32 1MB 512MB
sudo parted $DISK -- set 2 esp on
sudo parted $DISK -- set 2 boot on
sudo parted $DISK -- print all

# /boot
sudo mkfs.vfat -F 32 -n BOOTFS -v $DISK'p2'

# LUKS partition
sudo cryptsetup --verify-passphrase -v luksFormat $DISK'p1'
# >>> YES; create passphrase for LUKS partition
sudo cryptsetup open $DISK'p1' enc
# re-enter passphrase to open LUKS partition for more partition management
#
[ -d /var/mapper/enc ] && {
	echo "Crypsetup failed"
	exit 1
}

# setup LVN, with root & swap logical volumes
# Initialize volumegroup `pool`
sudo vgcreate pool /dev/mapper/enc
sudo lvcreate -n swap --size 32G pool
sudo mkswap -L SWAPFS --verbose /dev/pool/swap
sudo lvcreate -n root --extents 100%FREE pool
sudo mkfs.btrfs -L ROOTFS --verbose /dev/pool/root

# Mount btrfs root partition to initialize subvolumes
sudo mount -t btrfs /dev/pool/root /mnt

# Create subvolumes under btrfs root partition
sudo btrfs subvolume create /mnt/root
sudo btrfs subvolume create /mnt/home
sudo btrfs subvolume create /mnt/nix
sudo btrfs subvolume create /mnt/persist
sudo btrfs subvolume create /mnt/log

# Take an empty readonly snapshot of the btrfs root
sudo btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
sudo umount /mnt

# mount paritions in preparation for installation
sudo mount -o subvol=root,compress=zstd,noatime /dev/pool/root /mnt/

sudo mkdir -p /mnt/{boot,home,nix,persist,var/log}
sudo mount -o subvol=home,compress=zstd,noatime /dev/pool/root /mnt/home
sudo mount -o subvol=nix,compress=zstd,noatime /dev/pool/root /mnt/nix
sudo mount -o subvol=persist,compress=zstd,noatime /dev/pool/root /mnt/persist
sudo mount -o subvol=log,compress=zstd,noatime /dev/pool/root /mnt/var/log
sudo mount $DISK'p2' /mnt/boot

sudo nixos-generate-config --root /mnt

sudo nix-env -iA nixos.gettext nixos.moreutils nixos.neovim

sudo curl -sSL $configuration_url -o configuration.nix
sudo curl -sSL $hardware_url -o hardware-configuration.nix

export HOSTNAME=$hostname
export TIMEZONE=$timezone
export DEFAULT_LOCALE=$default_locale
export EXTRA_LOCALE=$extra_locale
export DEFAULT_USER=$default_user
export XKB_LAYOUT=$xkb_layout
export XKB_VARIANT=$xkb_variant
export XKB_OPTIONS=$xkb_options
export CONSOLE_KEYBOARD_LAYOUT=$console_keyboard_layout

envsubst < configuration.nix | sudo sponge /mnt/etc/nixos/configuration.nix
