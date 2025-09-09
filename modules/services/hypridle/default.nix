{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "services.hypridle";
  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: {
    services.hypridle.enable = true;
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [hypridle];
  };
}
