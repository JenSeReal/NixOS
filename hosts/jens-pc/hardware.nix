{delib, ...}:
delib.host rec {
  name = "jens-pc";
  system = "x86_64-linux";

  home.home.stateVersion = "25.05";
  nixos = {
    nixpkgs.hostPlatform = system;
    system.stateVersion = "25.05";
  };
  darwin = {
    system.stateVersion = 6;
  };

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
      framework.enable = true;
      graphics.enable = true;
      touchpad.enable = true;
    };
    services.fwupd.enable = true;
    power-management.enable = true;
  };
}
