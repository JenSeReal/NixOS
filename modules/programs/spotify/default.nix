{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.spotify";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [spotify];
  };

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [spotify];
  };
}
