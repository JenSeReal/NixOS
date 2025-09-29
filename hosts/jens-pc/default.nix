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
      keychron.enable = true;
      moza-r12.enable = true;
    };
    programs = {
      bat.enable = true;
      # bottles.enable = true;
      btop.enable = true;
      carapace.enable = true;
      sudo.enable = true;
      fish.enable = true;
      nh.enable = true;
      nu.enable = true;
      quickemu.enable = true;
      starship.enable = true;
      steam.enable = true;
      vesktop.enable = true;
      wezterm.enable = true;
      zed.enable = true;
    };
  };
}
