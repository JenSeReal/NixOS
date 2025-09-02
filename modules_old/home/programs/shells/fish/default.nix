{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.JenSeReal.programs.shells.fish;
  is-darwin = pkgs.stdenv.isDarwin;
in
{
  options.JenSeReal.programs.shells.fish = {
    enable = mkEnableOption "Enable fish.";
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      shellInit = ''
        ${if is-darwin then "set fish_emoji_width 2" else ""}
      '';
    };
  };
}
