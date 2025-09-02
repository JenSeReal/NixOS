{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.nu";

  options = with delib;
    moduleOptions {
      enable = boolOption false;
    };
  home.ifEnabled = {...}: {};

  darwin.ifEnabled = {...}: {
    environment.systemPackages = [pkgs.nushell];
    environment.shells = [pkgs.nushell];
  };

  nixos.ifEnabled = {...}: {
  };
}
