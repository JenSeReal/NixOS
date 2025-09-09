{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.nu";
  options = delib.singleEnableOption false;

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [nushell];
    environment.shells = with pkgs; [nushell];
  };

  home.ifEnabled = {...}: {};

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [nushell];
    environment.shells = with pkgs; [nushell];
  };
}
