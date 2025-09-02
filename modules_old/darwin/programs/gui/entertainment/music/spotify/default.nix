{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.gui.entertainment.music.spotify;
in
{
  imports = [
    (lib.snowfall.fs.get-file "modules/common/programs/gui/entertainment/music/spotify/default.nix")
  ];

  config = mkIf cfg.enable { };
}
