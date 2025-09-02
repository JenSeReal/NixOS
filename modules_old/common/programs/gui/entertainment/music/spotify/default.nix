{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.entertainment.music.spotify;
in
{
  options.${namespace}.programs.gui.entertainment.music.spotify = {
    enable = mkEnableOption "Spotify.";
  };
  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ spotify ]; };
}
