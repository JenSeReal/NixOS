{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.JenSeReal.desktop.environments.yabai;
in
{
  options.JenSeReal.desktop.environments.yabai = {
    enable = mkEnableOption "Enable Yabai desktop environment";
  };

  config = mkIf cfg.enable {
    JenSeReal.desktop.window-managers.yabai.enable = true;
    JenSeReal.programs.tools.skhd.enable = true;
    JenSeReal.desktop.bars.sketchybar.enable = true;
  };
}
