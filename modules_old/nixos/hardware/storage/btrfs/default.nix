{ config, lib, pkgs, inputs, ... }:
with lib;
with lib.JenSeReal;

let cfg = config.JenSeReal.hardware.storage.btrfs;
in {
  options.JenSeReal.hardware.storage.btrfs = with types; {
    enable = mkEnableOption "Whether or not to enable btrfs.";

  };

  config = mkIf cfg.enable { };
}
