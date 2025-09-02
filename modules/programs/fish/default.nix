{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.fish";

  options = with delib;
    moduleOptions {
      enable = boolOption false;
    };
  home.ifEnabled = {...}: {};

  darwin.ifEnabled = {...}: {
    programs.fish = {
      enable = true;
    };
    environment.shells = [pkgs.fish];
  };

  nixos.ifEnabled = {...}: {
  };
}
