{
  config,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};

let
  cfg = config.${namespace}.desktop.display-manager.sddm;
in
{
  options.${namespace}.desktop.display-manager.sddm = with types; {
    enable = mkEnableOption "Whether or not to enable sddm display manager.";
  };

  config = mkIf cfg.enable {

  };
}
