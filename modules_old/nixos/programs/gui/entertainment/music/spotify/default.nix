{ config, lib, ... }:
let
  inherit (lib) mkIf;

  cfg = config.JenSeReal.system.font;
in
{
  imports = [
    (lib.snowfall.fs.get-file "modules/common/programs/gui/entertainment/music/spotify/default.nix")
  ];

  config = mkIf cfg.enable { };
}
