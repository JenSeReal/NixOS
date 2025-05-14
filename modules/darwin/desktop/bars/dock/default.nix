{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.desktop.bars.dock;
in
{
  options.${namespace}.desktop.bars.dock = {
    enable = mkEnableOption "Wether to enable dock configuration.";
  };

  config = mkIf cfg.enable {
    system.defaults.dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.2;
      appswitcher-all-displays = true;
      expose-animation-duration = 0.2;
      mineffect = "scale";
      minimize-to-application = true;
      mouse-over-hilite-stack = true;
      tilesize = 48;
      launchanim = false;
      static-only = false;
      showhidden = true;
      show-recents = false;
      show-process-indicators = true;
      orientation = "bottom";
      persistent-apps = [
        "/Applications/Firefox.app"
        "/Applications/Slack.app"
        "/Applications/Microsoft Outlook.app"
        "/Applications/Microsoft Teams.app"
        "/Applications/zoom.us.app"
      ];
      mru-spaces = false;
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
    };
  };
}
