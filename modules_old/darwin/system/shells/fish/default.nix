{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.system.shells.fish;
in
{
  options.${namespace}.system.shells.fish = {
    enable = mkBoolOpt true "Wether to enable fish shell.";
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
    };
    environment.shells = [ pkgs.fish ];

  };
}
