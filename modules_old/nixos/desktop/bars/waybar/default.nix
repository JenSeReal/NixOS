{ options, config, lib, pkgs, ... }:

with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.desktop.bars.waybar;
in
{
  options.JenSeReal.desktop.bars.waybar = with types; {
    enable =
      mkBoolOpt false "Whether or not to use waybar as the bar.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      waybar
    ];
  };
}
