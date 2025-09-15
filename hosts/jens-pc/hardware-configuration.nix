{...}: {
  boot.initrd.luks.devices."enc" = {
    device = "/dev/disk/by-partlabel/ROOTPART";
    preLVM = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/ROOTFS";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd" "noatime" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/ROOTFS";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/ROOTFS";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd" "noatime" ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-label/ROOTFS";
    fsType = "btrfs";
    options = [ "subvol=persist" "compress=zstd" "noatime" ];
    neededForBoot = true;
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-label/ROOTFS";
    fsType = "btrfs";
    options = [ "subvol=log" "compress=zstd" "noatime" ];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOTFS";
    fsType = "vfat";
  };

  swapDevices = [{ device = "/dev/disk/by-label/SWAPFS"; }];
}
