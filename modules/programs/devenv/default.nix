{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.devenv";

  options = with delib;
    moduleOptions {
      enable = boolOption false;
    };

  home.ifEnabled = {...}: {};

  darwin.ifEnabled = {...}: {
    myconfig.programs.direnv.enable = true;
    environment.systemPackages = with pkgs; [
      devenv
    ];
  };

  nixos.ifEnabled = {...}: {
  };
}
