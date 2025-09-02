{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkStrOpt;
  cfg = config.${namespace}.system.keyboard;
in
{

  options.${namespace}.system.keyboard = {
    enable = mkEnableOption "Options for the keyboard.";
    xkb_layout = mkStrOpt "de" "The xkb layout for the keyboard";
    xkb_variant = mkStrOpt "nodeadkeys" "The xkb variant for the keyboard";
    xkb_options = mkStrOpt "caps:escape" "The xkb options for the keyboard";
  };

  config = mkIf cfg.enable {
    services.xserver.xkb = {
      layout = cfg.xkb_layout;
      variant = cfg.xkb_variant;
      options = cfg.xkb_options;
    };

    console = {
      packages = [ pkgs.terminus_font ];
      font = "${pkgs.terminus_font}/share/consolefonts/ter-v16n.psf.gz";
      useXkbConfig = true;
    };

    environment.sessionVariables = {
      XKB_LAYOUT = cfg.xkb_layout;
      XKB_VARIANT = cfg.xkb_variant;
      XKB_OPTIONS = cfg.xkb_options;
    };
  };
}
