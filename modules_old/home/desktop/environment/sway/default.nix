{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;
  cfg = config.${namespace}.desktop.environment.sway;
in {
  options.${namespace}.desktop.environment.sway = {
    enable = mkBoolOpt false "Whether or not to enable sway desktop enivronment.";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      programs.desktop.screen-lockers.swaylock.enable = true;
      desktop = {
        window-manager.wayland.sway = enabled;
        bars.waybar = enabled;
        layout-manager.kanshi = enabled;
        service.swayidle = enabled;
        wallpaper.swww = enabled;
      };
    };
  };
}
