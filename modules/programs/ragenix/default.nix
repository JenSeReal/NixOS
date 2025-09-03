{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.ragenix";

  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: {};

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [ragenix];
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [ragenix];
  };
}
