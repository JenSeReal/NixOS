#!/usr/bin/env bash

# NixOS Installation Script with LUKS encryption and BTRFS subvolumes
# Fixed version addressing partition ordering and other issues

configuration_url=https://raw.githubusercontent.com/JenSeReal/NixOS/main/bootstrap/configuration.nix
hardware_url=https://raw.githubusercontent.com/JenSeReal/NixOS/main/bootstrap/hardware-configuration.nix

# Collect user input
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

read -p "Enter the xkb options [caps:escape]: " xkb_options
xkb_options=${xkb_options:-"caps:escape"}

read -p "Enter the console keyboard layout [de-latin1-nodeadkeys]: " console_keyboard_layout
console_keyboard_layout=${console_keyboard_layout:-"de-latin1-nodeadkeys"}

read -p "Enter the disk name [/dev/nvme0n1]: " DISK
DISK=${DISK:-"/dev/nvme0n1"}

echo "WARNING: This will completely wipe $DISK"
read -p "Are you sure you want to continue? [y/N]: " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "Installation cancelled."
    exit 1
fi

# Partition root and boot (FIXED ORDER)
echo "Creating partition table..."
sudo parted $DISK -- mklabel gpt
sudo parted $DISK -- mkpart ESPPART fat32 1MB 512MB
sudo parted $DISK -- mkpart ROOTPART 512MB 100%
sudo parted $DISK -- set 1 esp on
sudo parted $DISK -- set 1 boot on
sudo parted $DISK -- print all

# Format /boot partition (CORRECTED: p1 is now the boot partition)
echo "Formatting boot partition..."
sudo mkfs.vfat -F 32 -n BOOTFS -v ${DISK}p1

# LUKS partition setup (CORRECTED: p2 is now the root partition)
echo "Setting up LUKS encryption..."
sudo cryptsetup --verify-passphrase -v luksFormat ${DISK}p2
echo "Opening LUKS partition..."
sudo cryptsetup open ${DISK}p2 enc

# Check if cryptsetup succeeded (FIXED LOGIC)
if [ ! -e /dev/mapper/enc ]; then
    echo "Cryptsetup failed - encrypted device not found"
    exit 1
fi

# Setup LVM with root & swap logical volumes
echo "Setting up LVM..."
sudo vgcreate pool /dev/mapper/enc
sudo lvcreate -n swap --size 32G pool
sudo mkswap -L SWAPFS --verbose /dev/pool/swap
sudo swapon /dev/pool/swap  # ADDED: Activate swap
sudo lvcreate -n root --extents 100%FREE pool
sudo mkfs.btrfs -L ROOTFS --verbose /dev/pool/root

# Mount btrfs root partition to initialize subvolumes
echo "Creating BTRFS subvolumes..."
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

# Mount partitions in preparation for installation
echo "Mounting partitions for installation..."
sudo mount -o subvol=root,compress=zstd,noatime /dev/pool/root /mnt/

sudo mkdir -p /mnt/{boot,home,nix,persist,var/log}
sudo mount -o subvol=home,compress=zstd,noatime /dev/pool/root /mnt/home
sudo mount -o subvol=nix,compress=zstd,noatime /dev/pool/root /mnt/nix
sudo mount -o subvol=persist,compress=zstd,noatime /dev/pool/root /mnt/persist
sudo mount -o subvol=log,compress=zstd,noatime /dev/pool/root /mnt/var/log

# Mount boot partition (CORRECTED: p1 is the boot partition)
sudo mount ${DISK}p1 /mnt/boot

# Generate initial hardware configuration
echo "Generating NixOS configuration..."
sudo nixos-generate-config --root /mnt

# Install required tools
echo "Installing required tools..."
sudo nix-env -iA nixos.gettext nixos.moreutils nixos.neovim

# Download configuration files
echo "Downloading configuration files..."
sudo curl -sSL $configuration_url -o configuration.nix
sudo curl -sSL $hardware_url -o hardware-configuration.nix

# Set environment variables for substitution
export HOSTNAME=$hostname
export TIMEZONE=$timezone
export DEFAULT_LOCALE=$default_locale
export EXTRA_LOCALE=$extra_locale
export DEFAULT_USER=$default_user
export XKB_LAYOUT=$xkb_layout
export XKB_VARIANT=$xkb_variant
export XKB_OPTIONS=$xkb_options
export CONSOLE_KEYBOARD_LAYOUT=$console_keyboard_layout

# Apply environment variable substitution and install configuration
echo "Applying configuration..."
envsubst < configuration.nix | sudo sponge /mnt/etc/nixos/configuration.nix

# Copy hardware configuration if it was downloaded
if [ -f hardware-configuration.nix ]; then
    sudo cp hardware-configuration.nix /mnt/etc/nixos/hardware-configuration.nix
fi

# Run NixOS installation
echo "Starting NixOS installation..."
sudo nixos-install

if [ $? -eq 0 ]; then
    echo "NixOS installation completed successfully!"
    
    # Set user password after installation
    echo "Setting up user password..."
    echo "Please set a password for user: $default_user"
    sudo nixos-enter --root /mnt -c "passwd $default_user"
    
    echo ""
    echo "Installation completed successfully!"
    echo "System will reboot now. After reboot, you can login with:"
    echo "  Username: $default_user"
    echo "  Password: [the password you just set]"
    echo ""
    
    read -p "Reboot now? [Y/n]: " reboot_confirm
    if [ "$reboot_confirm" != "n" ] && [ "$reboot_confirm" != "N" ]; then
        echo "Rebooting in 5 seconds... (Ctrl+C to cancel)"
        sleep 5
        sudo reboot
    else
        echo "You can reboot manually when ready with: sudo reboot"
    fi
else
    echo "NixOS installation failed! Please check the error messages above."
    exit 1
fi
