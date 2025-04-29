{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  inherit (lib.${namespace}) enabled mkPackageOpt;

  cfg = config.${namespace}.desktop.window-managers.aerospace;
in
{
  options.${namespace}.desktop.window-managers.aerospace = {
    enable = mkEnableOption "Enable aerospace";
    package = mkPackageOpt pkgs.aerospace "The default package to use";
  };

  config = mkIf cfg.enable {
    # JenSeReal.programs.cli.homebrew = {
    #   enable = true;
    #   additional_casks = [ "nikitabobko/tap/aerospace" ];
    #   additional_taps = [ "nikitabobko/tap" ];
    # };

    environment.systemPackages = [
      cfg.package
    ];

    JenSeReal.desktop.addons.jankyborders = enabled;

    # launchd.user.agents.aerospace = {
    #   command = "/Applications/AeroSpace.app/Contents/MacOS/AeroSpace --config-path ${configFile}";
    #   serviceConfig = {
    #     KeepAlive = true;
    #     RunAtLoad = true;
    #   };
    # };
  };
}
