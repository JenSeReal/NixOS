{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.wlogout";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [wlogout];
  };
}
