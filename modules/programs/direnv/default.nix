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

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [
      direnv
      nix-direnv
    ];
  };

  nixos.ifEnabled = {...}: {
  };
}
