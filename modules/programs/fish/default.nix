{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.fish";
  options = delib.singleEnableOption false;

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
