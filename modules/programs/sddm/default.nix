{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.sddm";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [sddm];
  };
}
