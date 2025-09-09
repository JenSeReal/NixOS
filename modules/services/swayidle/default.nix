{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "services.mako";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [swayidle];
  };
}
