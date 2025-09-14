{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.bitwarden";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [bitwarden-desktop];
  };

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [bitwarden-desktop];
  };
}
