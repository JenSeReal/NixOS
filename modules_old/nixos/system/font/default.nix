{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.JenSeReal.system.fonts;
in
{
  imports = [ (lib.snowfall.fs.get-file "modules/common/system/fonts/default.nix") ];

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      font-manager
      fontpreview
    ];
    fonts.fontDir.enable = true;
  };
}
