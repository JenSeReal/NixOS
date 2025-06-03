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
      settings = {
        build-users-group = "nixbld";

        extra-sandbox-paths = [
          "/System/Library/Frameworks"
          "/System/Library/PrivateFrameworks"
          "/usr/lib"
          "/private/tmp"
          "/private/var/tmp"
          "/usr/bin/env"
        ];

        # FIX: shouldn't disable, but getting sandbox max size errors on darwin
        # darwin-rebuild --rollback on testing changing
        sandbox = lib.mkForce false;
      };
      extraOptions = ''
        connect-timeout = 10
        keep-going = true
        always-allow-substitutes = true
      '';
      gc = {
        interval = {
          Day = 1;
          Hour = 12;
          Minute = 0;
        };
      };
      optimise = {
        interval = {
          Day = 1;
          Hour = 12;
          Minute = 15;
        };
      };
    };
  };
}
