{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.waybar";
  options = delib.singleEnablxeOption false;

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [waybar];
  };
}
