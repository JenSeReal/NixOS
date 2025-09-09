{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.way-displays";
  options = delib.singleEnablxeOption false;

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [way-displays];
    JenSeReal.user.extraGroups = ["input"];
  };
}
