{
  delib,
  inputs,
  modulesPath,
  ...
}:
delib.deploy {
  name = "midnight-runner";
  system = "x86_64-linux";
  type = "server";

  home.home.stateVersion = "25.05";
  nixos = {
    imports = [
      inputs.disko.nixosModules.disko
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "25.05";

    boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = [];
    boot.extraModulePackages = [];

    disko.devices.disk.midnight-runner-main = {
      type = "disk";
      device = "/dev/vda";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1M";
            type = "EF02";
          };
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
