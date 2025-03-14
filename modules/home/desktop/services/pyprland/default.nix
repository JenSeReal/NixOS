{
  config,
  lib,
  pkgs,
  ...
}:
let

  inherit (lib)
    mkEnableOption
    getExe
    mkOption
    types
    optional
    ;

  cfg = config.services.pyprland;
  settingsFormat = pkgs.formats.toml { };
in
{
  options.services.pyprland = {
    enable = mkEnableOption "pyprland";

    package = mkOption {
      default = pkgs.pyprland;
      type = types.package;
      description = "The pyprland package to use";
    };

    extraPlugins = mkOption {
      default = [ ];
      type = with types; listOf str;
      description = "Additional plugins to enable";
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;

        options.scratchpads = mkOption {
          default = { };
          type = with types; attrsOf attrs;
          description = "Scratchpad configurations";
        };
      };
      default = { };
      description = ''
        Configuration for pyprland, see
        <https://github.com/hyprland-community/pyprland/wiki/Getting-started#configuring">
        for supported values.
      '';
    };

    home.packages = [ cfg.package ];

    services.pyprland.settings = {
      pyprland = {
        plugins = cfg.extraPlugins ++ (optional (cfg.settings.scratchpads != { }) "scratchpads");
      };
    };

    wayland.windowManager.hyprland.settings.exec-once = [ (getExe pkgs.pyprland) ];
    home.file.".config/hypr/pyprland.toml".source =
      settingsFormat.generate "pyprland-config.toml" cfg.settings;

  };
}
