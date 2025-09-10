{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.way-displays";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    home.packages = with pkgs; [way-displays];
    xdg.configFile."way-displays/cfg.yaml".source = ./cfg.yaml;
  };

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [way-displays];
    JenSeReal.user.extraGroups = ["input"];
  };
}
