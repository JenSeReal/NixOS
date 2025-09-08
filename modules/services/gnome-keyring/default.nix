{delib, ...}:
delib.module {
  name = "services.gnome-keyring";
  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: {};

  nixos.ifEnabled = {...}: {
    programs.seahorse.enable = true;
    services.gnome.gnome-keyring.enable = true;
  };
}
