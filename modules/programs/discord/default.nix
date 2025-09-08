{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.discord";
  options = delib.singleEnableOption false;

  nixos = {
    environment.systemPackages = with pkgs; [
      vesktop
    ];
  };
}
