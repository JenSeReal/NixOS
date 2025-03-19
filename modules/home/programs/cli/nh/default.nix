{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.cli.nh;
in
{
  options.${namespace}.programs.cli.nh = {
    enable = mkEnableOption "Whether or not to enable nh.";
  };

  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
      # clean.enable = true;
      # clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "${config.home.homeDirectory}/nixos";
    };
  };
}
