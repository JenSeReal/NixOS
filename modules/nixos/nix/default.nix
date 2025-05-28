{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nix;
in {
  imports = [(lib.snowfall.fs.get-file "modules/common/nix/default.nix")];

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
