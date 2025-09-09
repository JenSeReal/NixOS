{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.wlogout";
  options = delib.singleEnablxeOption false;

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [wlogout];
  };
}
