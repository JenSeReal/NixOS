{delib, ...}:
delib.host {
  name = "jens-pc";

  rice = "synthwave86";
  type = "laptop";

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
