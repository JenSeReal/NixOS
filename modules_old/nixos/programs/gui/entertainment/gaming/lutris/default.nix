{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib) types mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt;
  inherit (types) listOf package;

  cfg = config.${namespace}.programs.gui.entertainment.gaming.lutris;
in
{
  options.${namespace}.programs.gui.entertainment.gaming.lutris = {
    enable = mkEnableOption "Whether or not to enable pipewire.";
    extraLibraries = mkOpt (listOf package) [ ] "Extra libraries needed for Lutris games";
    extraPackages = mkOpt (listOf package) [ ] "Extra packages needed for Lutris games";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.wineWowPackages.waylandFull
      pkgs.winetricks
      pkgs.protontricks
      pkgs.protonup-qt
      pkgs.vulkan-tools
      (pkgs.lutris.override {
        extraPkgs =
          pkgs:
          cfg.extraPackages
          ++ [
            pkgs.wineWowPackages.waylandFull
            pkgs.winetricks
            pkgs.protontricks
          ];
        extraLibraries = pkgs: cfg.extraLibraries;
      })
    ];
  };
}
