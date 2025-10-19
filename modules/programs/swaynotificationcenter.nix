{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.swaynotificationcenter";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [swaynotificationcenter];
  };
}
