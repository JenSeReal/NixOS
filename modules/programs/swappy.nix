{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.swappy";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [swappy];
  };
}
