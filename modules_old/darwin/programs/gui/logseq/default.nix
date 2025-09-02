{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.gui.logseq;
in
{
  options.${namespace}.programs.gui.logseq = {
    enable = mkEnableOption "Wether to enable logseq.";
  };

  config = mkIf cfg.enable {
    JenSeReal.programs.cli.homebrew = {
      enable = true;
      additional_casks = [ "logseq" ];
    };
    launchd.user.agents.logseq = {
      command = "/Applications/Logseq.app/Contents/MacOS/Logseq";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
      };
    };
  };
}
