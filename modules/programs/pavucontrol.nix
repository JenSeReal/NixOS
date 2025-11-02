{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.pavucontrol";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [pavucontrol];
  };
}
