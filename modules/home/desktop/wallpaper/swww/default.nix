{
  config,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.desktop.wallpaper.swww;
in
{
  options.${namespace}.desktop.wallpaper.swww = {
    enable = mkBoolOpt false "Whether to enable swww service.";
  };
  config = mkIf cfg.enable { services.swww.enable = true; };
}
