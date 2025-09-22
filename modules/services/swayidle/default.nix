{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "services.swayidle";
  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: {
    services.swayidle.enable = true;
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [swayidle];
  };
}
