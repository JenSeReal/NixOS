{ delib, ... }:
delib.host {
  name = "jens-pc";

  rice = "synthwave86";
  type = "laptop";

  myconfig = {
    desktop-environments.hyprland.enable = true;
  };
}
