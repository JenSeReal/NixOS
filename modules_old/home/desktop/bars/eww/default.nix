{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;
  cfg = config.${namespace}.desktop.bars.eww;
in
{
  options.${namespace}.desktop.bars.eww = {
    enable = mkBoolOpt false "Whether or not to enable eww.";
  };

  config = mkIf cfg.enable {
    programs.eww = {
      enable = true;
      configDir = ./config;
    };
  };
}
