{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.gui.miro;
in
{
  options.${namespace}.programs.gui.miro = {
    enable = mkEnableOption "Wether to enable miro.";
  };

  config = mkIf cfg.enable {
    JenSeReal.programs.cli.homebrew = {
      enable = true;
      additional_casks = [ "miro" ];
    };
    launchd.user.agents.miro = {
      command = "/Applications/Miro.app/Contents/MacOS/Miro";
      serviceConfig = {
        KeepAlive = false;
        RunAtLoad = true;
      };
    };
  };
}
