{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.hyprlock";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [hyprlock];
  };
}
