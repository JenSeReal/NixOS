{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.desktop.addons.jankyborders;
in
{
  options.${namespace}.desktop.addons.jankyborders = {
    enable = mkEnableOption "Wether to enable janky boarders";
  };

  config = mkIf cfg.enable { services.jankyborders = enabled; };
}
