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
    programs = {
      carapace.enable = true;
      fish.enable = true;
      nh.enable = true;
      nu.enable = true;
      starship.enable = true;
      zed.enable = true;
    };
  };
}
