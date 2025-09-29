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

  myconfig = {
    boot = {
      enable = true;
      plymouth = true;
      secureBoot = true;
    };
    desktop-environments.hyprland.enable = true;
    hardware = {
      bluetooth.enable = true;
      fingerprint.enable = true;
      graphics.enable = true;
      touchpad.enable = true;
    };
    services.fwupd.enable = true;
    power-management.enable = true;
  };

  nixos = {
    imports = [
      inputs.ucodenix.nixosModules.default
      inputs.nixos-hardware.nixosModules.framework-13-7040-amd
      ./hardware-configuration.nix
    ];

    services.ucodenix.enable = true;
    boot.kernelParams = ["microcode.amd_sha_check=off"];

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
