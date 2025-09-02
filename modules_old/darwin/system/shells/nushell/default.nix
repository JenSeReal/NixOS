{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.system.shells.nu;
in
{
  options.${namespace}.system.shells.nu = {
    enable = mkBoolOpt true "Wether to enable nu shell.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.nushell ];
    environment.shells = [ pkgs.nushell ];
  };
}
