{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.JenSeReal.system.shells.nushell;
in
{
  options.JenSeReal.system.shells.nushell = {
    enable = mkEnableOption "Whether or not to use nuhsell as a shell.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nushell ];
    environment.shells = with pkgs; [ nushell ];
  };
}
