{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.fish";
  options = delib.singleEnableOption false;

  darwin.ifEnabled = {...}: {
    programs.fish.enable = true;
    environment.shells = with pkgs; [fish];
  };

  home.ifEnabled = {...}: {};

  nixos.ifEnabled = {...}: {
    programs.fish.enable = true;
    environment.shells = with pkgs; [fish];
  };
}
