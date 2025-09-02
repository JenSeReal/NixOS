

{ config, lib, ... }:
with lib;
with lib.JenSeReal;

let cfg = config.JenSeReal.services.fwupd;
in {
  options.JenSeReal.services.fwupd = with types; {
    enable = mkEnableOption "Whether to enable sops.";
  };

  config = mkIf cfg.enable {
    services.fwupd = {
      enable = true;
      extraRemotes = [ "lvfs-testing" ];
    };
  };
}
