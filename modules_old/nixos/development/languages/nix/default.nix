{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.JenSeReal.development.languages.nix;
in
{
  options.JenSeReal.development.languages.nix = {
    enable = mkEnableOption "Nix development.";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nix
      nixpkgs-fmt
      nil
      nixfmt-rfc-style
    ];
  };
}
