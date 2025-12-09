{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.atuin";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.atuin;
    };

  home.ifEnabled = {cfg, ...}: {
    programs.atuin = {
      enable = true;
      package = cfg.package;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
