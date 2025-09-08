{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "services.hypridle";
  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: {};

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [hypridle];
  };
}
