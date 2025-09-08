{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.sddm";
  options = delib.singleEnablxeOption false;

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [sddm];
  };
}
