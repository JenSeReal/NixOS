{
  delib,
  pkgs,
  homeconfig,
  ...
}:
delib.module {
  name = "programs.nh";
  options = with delib;
    moduleOptions {
      enable = boolOption true;
      package = packageOption pkgs.unstable.nh;
    };

  home.ifEnabled = {...}: {
    programs.nh = {
      enable = true;
      flake = "${homeconfig.home.homeDirectory}/NixOS";
    };
  };

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [nh];
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [nh];
  };
}
