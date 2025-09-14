{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.direnv";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
    };

  home.ifEnabled = {
    home.packages = with pkgs; [devenv];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [
      devenv
      direnv
      nix-direnv
    ];
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [
      devenv
      direnv
      nix-direnv
    ];
  };
}
