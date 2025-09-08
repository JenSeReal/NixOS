{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.nu";
  options = delib.singleEnableOption false;

  darwin.ifEnabled = {...}: {
    environment.systemPackages = [pkgs.nushell];
    environment.shells = [pkgs.nushell];
  };

  home.ifEnabled = {...}: {};

  nixos.ifEnabled = {...}: {};
}
