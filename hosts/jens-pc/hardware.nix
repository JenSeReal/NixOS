{
  delib,
  pkgs,
  inputs,
  config,
  ...
}:
delib.host {
  name = "jens-pc";

  system = "x86_64-linux";

  home.home.stateVersion = "25.05";

  nixos = {
    imports = [
      inputs.ucodenix.nixosModules.default
      inputs.nixos-hardware.nixosModules.framework-13-7040-amd
      ./hardware-configuration.nix
    ];

    services.ucodenix.enable = true;

    # Bootloader settings
    boot.initrd.systemd.enable = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.systemd-boot.enable = true;
    boot.supportedFilesystems = [
      "btrfs"
      "ntfs"
      "fat32"
    ];
    boot.kernelParams = ["microcode.amd_sha_check=off"];
    hardware.enableAllFirmware = true;
    boot.extraModulePackages = with config.boot.kernelPackages; [framework-laptop-kmod];

    environment.systemPackages = with pkgs; [
      curl
      git
      framework-tool
      fw-ectool
    ];

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "25.05";
  };

  darwin = {
    system.stateVersion = 6;
  };
}
