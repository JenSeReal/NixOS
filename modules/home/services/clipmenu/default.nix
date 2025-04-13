{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;
  inherit (lib.${namespace}) enabled;

  cfg = config.JenSeReal.services.clipmenu;
in
{
  options.JenSeReal.services.clipmenu = {
    enable = mkEnableOption "clipmenu";
  };

  config = mkIf cfg.enable {
    services.clipmenu = enabled;
  };
}
