{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.discord";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [
      discord
    ];
  };
}
