{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.programs.cli.direnv;
in {
  options.${namespace}.programs.cli.direnv = {
    enable = mkEnableOption "Whether or not to enable direnv.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs.unstable; [devenv];

    programs.direnv = {
      enable = true;
      nix-direnv = enabled;
      silent = true;
    };
  };
}
