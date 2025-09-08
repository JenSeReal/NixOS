{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.ragenix";
  options = delib.singleEnableOption false;

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [ragenix];
  };

  home.ifEnabled = {...}: {};

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [ragenix];
  };
}
