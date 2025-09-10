{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.swww";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    services.swww.enable = true;
  };

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [swww];
  };
}
