{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.aerospace";

  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.aerospace;
    };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [
      cfg.package
    ];

    # TODO: change aerospace config
    launchd.agents.aerospace = {
      serviceConfig = {
        Program = "${cfg.package}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace";
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/tmp/aerospace.log";
        StandardErrorPath = "/tmp/aerospace.err.log";
      };
    };
  };

  home.ifEnabled = {cfg, ...}: {
    programs.aerospace = {
      enable = true;
      package = cfg.package;
    };
  };
}
