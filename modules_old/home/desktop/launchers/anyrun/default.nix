{
  config,
  lib,
  inputs,
  system,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) anyrun anyrun-nixos-options;

  cfg = config.JenSeReal.desktop.launchers.anyrun;
in
{
  options.JenSeReal.desktop.launchers.anyrun = {
    enable = mkEnableOption "Anyrun.";
  };

  config = mkIf cfg.enable {
    # programs.anyrun = {
    #   enable = true;
    #   config = {
    #     plugins = with anyrun.packages.${system}; [
    #       applications
    #       dictionary
    #       rink
    #       shell
    #       symbols
    #       stdin
    #       translate
    #       websearch

    #       anyrun-nixos-options.packages.${system}.default
    #     ];
    #     width = {
    #       fraction = 0.3;
    #     };
    #     hideIcons = false;
    #     ignoreExclusiveZones = false;
    #     layer = "overlay";
    #     hidePluginInfo = false;
    #     closeOnClick = false;
    #     showResultsImmediately = false;
    #     maxEntries = null;
    #   };
    # };
  };
}
