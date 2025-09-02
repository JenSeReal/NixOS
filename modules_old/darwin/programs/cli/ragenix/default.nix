{
  config,
  lib,
  namespace,
  inputs,
  system,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.cli.ragenix;
in
{
  options.${namespace}.programs.cli.ragenix = {
    enable = mkEnableOption "Wether to enable ragenix.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ inputs.ragenix.packages.${system}.default ];
  };
}
