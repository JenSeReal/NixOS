{
  delib,
  pkgs,
  ...
}:
delib.host {
  name = "jens-pc";

  rice = "synthwave84";
  type = "laptop";

  nixos = {
    users.defaultUserShell = pkgs.nushell;
  };

  myconfig = {
    desktop-environments.hyprland.enable = true;
    hardware = {
      bluetooth.enable = true;
      fingerprint.enable = true;
      graphics.enable = true;
      keychron.enable = true;
      moza-r12.enable = true;
      touchpad.enable = true;
    };
    programs = {
      carapace.enable = true;
      sudo.enable = true;
      fish.enable = true;
      nh.enable = true;
      nu.enable = true;
      starship.enable = true;
      steam.enable = true;
      vesktop.enable = true;
      zed.enable = true;
    };
    services.fwupd.enable = true;
    power-management.enable = true;
  };
}
