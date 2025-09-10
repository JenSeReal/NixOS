{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.wlr-randr";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [wlr-randr];
    JenSeReal.user.extraGroups = ["input"];
  };
}
