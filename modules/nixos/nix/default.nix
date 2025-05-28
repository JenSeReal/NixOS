{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.JenSeReal.nix;
in {
  options.JenSeReal.nix = {
    enable = mkEnableOption "Whether or not to enable additional nix config.";
  };

  imports = [(lib.snowfall.fs.get-file "modules/common/system/nix/default.nix")];

  config = mkIf cfg.enable {
    nix = {
      gc = {
        dates = "weekly";
      };

      optimise = {
        dates = ["weekly"];
      };

      settings = {
        trusted-users = ["@wheel"];
      };
    };
  };
}
