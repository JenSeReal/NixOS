{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.carapace";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [carapace];
  };
}
