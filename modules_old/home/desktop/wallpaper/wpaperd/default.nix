{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe getExe';
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.desktop.wallpaper.wpaperd;
in
{
  options.${namespace}.desktop.wallpaper.wpaperd = {
    enable = mkBoolOpt false "Whether to enable wpaperd service.";
  };

  config = mkIf cfg.enable {
    programs.wpaperd = {
      enable = true;
      settings = {
        default = {
          path = "/home/jfp/Pictures/wallpaper";
        };
      };
    };
  };
}
