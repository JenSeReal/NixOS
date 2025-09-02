{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.JenSeReal.security.bitwarden;
in
{
  options.JenSeReal.security.bitwarden = {
    enable = mkEnableOption "Whether to enable Bitwarden.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ bitwarden ]; };
}
