# configuration_bootstrap.nix
{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

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

  networking.hostName = "$HOSTNAME";
  networking.networkmanager.enable = true;

  time.timeZone = "$TIMEZONE";

  i18n.defaultLocale = "$DEFAULT_LOCALE";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "$EXTRA_LOCALE";
    LC_IDENTIFICATION = "$EXTRA_LOCALE";
    LC_MEASUREMENT = "$EXTRA_LOCALE";
    LC_MONETARY = "$EXTRA_LOCALE";
    LC_NAME = "$EXTRA_LOCALE";
    LC_NUMERIC = "$EXTRA_LOCALE";
    LC_PAPER = "$EXTRA_LOCALE";
    LC_TELEPHONE = "$EXTRA_LOCALE";
    LC_TIME = "$EXTRA_LOCALE";
  };

  users.users."$DEFAULT_USER" = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      firefox
      freshfetch
    ];
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "$DEFAULT_USER";

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver = {
    xkb.layout = "$XKB_LAYOUT";
    xkb.variant = "$XKB_VARIANT";
    xkb.options = "$XKB_OPTIONS";
    libinput.enable = true;
  };

  console.keyMap = "$CONSOLE_KEYBOARD_LAYOUT";

  services.printing.enable = true;

  sound.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = "nix-command flakes";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  environment.systemPackages = with pkgs; [
    btop
    curl
    git
    direnv
    nix-direnv
    tpm2-tss
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  system.stateVersion = "23.11";
}
