{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "services.swayidle";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [swayidle];
  };
}
