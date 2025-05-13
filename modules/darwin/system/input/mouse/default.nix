{
  config,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.${namespace}.system.input.mouse;
in
{
  options.${namespace}.system.input.mouse = {
    enable = mkEnableOption "Whether or not to manage mouse settings.";
  };

  config = mkIf cfg.enable {
    ${namespace}.programs.cli.homebrew = {
      enable = true;
      additional_casks = [
        "unnaturalscrollwheels"
      ];
    };

    system.defaults.".GlobalPreferences"."com.apple.mouse.scaling" = 1.0;

    launchd.user.agents.unnaturalscrollwheels = {
      command = "/Applications/UnnaturalScrollWheels.app/Contents/MacOS/UnnaturalScrollWheels";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
      };
    };
  };
}
