{
  delib,
  lib,
  pkgs,
  ...
}: let
  settingsFormat = pkgs.formats.toml {};
in
  delib.module {
    name = "services.pyprland";
    options = with delib;
      moduleOptions {
        enable = boolOption false;

        package = packageOption pkgs.pyprland;

        extraPlugins = listOfOption str [];

        settings = mkOption {
          type = types.submodule {
            freeformType = settingsFormat.type;

            options.scratchpads = mkOption {
              default = {};
              type = with types; attrsOf attrs;
              description = "Scratchpad configurations";
            };
          };
          default = {};
          description = ''
            Configuration for pyprland, see
            <https://github.com/hyprland-community/pyprland/wiki/Getting-started#configuring">
            for supported values.
          '';
        };
      };

    home.ifEnabled = {cfg, ...}: {
      home.packages = [cfg.package];

      services.pyprland.settings = {
        pyprland = {
          plugins = cfg.extraPlugins ++ (lib.optional (cfg.settings.scratchpads != {}) "scratchpads");
        };
      };

      wayland.windowManager.hyprland.settings.exec-once = [(lib.getExe pkgs.pyprland)];
      home.file.".config/hypr/pyprland.toml".source =
        settingsFormat.generate "pyprland-config.toml" cfg.settings;
    };

    nixos.ifEnabled = {...}: {
      environment.systemPackages = with pkgs; [pyprland];
    };
  }
