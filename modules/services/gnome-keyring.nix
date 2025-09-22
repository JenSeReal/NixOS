{delib, ...}:
delib.module {
  name = "services.gnome-keyring";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    programs.seahorse.enable = true;
    services.gnome.gnome-keyring.enable = true;
  };
}
