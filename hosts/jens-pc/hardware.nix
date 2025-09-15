{ delib, pkgs, ... }:
delib.host {
  name = "jens-pc";

  system = "x86_64-linux";

  home.home.stateVersion = "25.05";

  nixos = {
    imports = [ ./hardware-configuration.nix ];

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
  hardware.enableAllFirmware = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services = {
    xserver = {
      xkb.layout = "de";
      xkb.variant = "nodeadkeys";
      xkb.options = "caps:escape";
    };
    libinput.enable = true;
  };

  console.keyMap = "de-latin1-nodeadkeys";

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = "nix-command flakes";

  environment.systemPackages = with pkgs; [
    curl
    git
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
