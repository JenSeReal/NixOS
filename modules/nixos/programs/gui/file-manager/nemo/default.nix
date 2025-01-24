{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.JenSeReal.gui.file-manager.nemo;
in
{
  options.JenSeReal.gui.file-manager.nemo = {
    enable = mkEnableOption "Whether or not to enable nemo.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nemo-with-extensions ];
    services.gvfs.enable = true;
  };
}
