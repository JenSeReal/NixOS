{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.awscli";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.awscli2;
      enableSsmPlugin = boolOption true;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages =
      [cfg.package]
      ++ (if cfg.enableSsmPlugin then [pkgs.ssm-session-manager-plugin] else []);
  };
}
