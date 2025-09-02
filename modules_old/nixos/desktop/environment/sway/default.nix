{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.desktop.environment.sway;
in
{
  options.${namespace}.desktop.environment.sway = {
    enable = mkEnableOption "Whether or not to enable sway window manager.";
  };

  config = mkIf cfg.enable {
    ${namespace}.desktop = {
      window-manager.sway = enabled;
      display-manager.tuigreet = {
        enable = true;
        autoLogin = "jfp";
      };
    };

    environment.systemPackages = with pkgs; [
      grim
      slurp
      wl-clipboard
      mako
      kanshi
      nwg-displays
    ];
  };
}
