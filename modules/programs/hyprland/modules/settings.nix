{
  delib,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types mkOption;
in
  with delib; {
    settingsModule = types.submodule {
      options = {
        modifyer = mkOption {
          type = types.submodule {
            options = {
              mainMod = strOption "SUPER";
              mainModCtrl = strOption "SUPER_CONTROL";
              mainModShift = strOption "SUPER_SHIFT";
            };
          };
          default = {};
        };
        defaultPrograms = mkOption {
          type = types.submodule {
            options = {
              terminal = packageOption pkgs.wezterm;
              browser = packageOption pkgs.firefox;
              launcher = packageOption pkgs.yofi;
              secondaryLauncher = packageOption pkgs.anyrun;
              explorer = packageOption pkgs.nemo;
              screenLocker = packageOption pkgs.hyprlock;
            };
          };
          default = {};
        };
        submaps = mkOption {
          type = types.listOf (import ./submap.nix {inherit lib;}).submapModule;
          default = [];
          description = "List of submap configurations";
          example = lib.literalExpression ''
            [
              {
                name = "🎥 Recorder";
                trigger = "''${mainMod}, R";
                actions = {
                  bind = [
                    "s, exec, ''${toggle} ''${screen-recorder} -s -d ''${config.home.homeDirectory}/Pictures/Recordings"
                    "w, exec, ''${toggle} ''${screen-recorder} -w -d ''${config.home.homeDirectory}/Pictures/Recordings"
                  ];
                  bindm = [
                    "SUPER, mouse:272, movewindow"
                  ];
                };
                exit = {
                  bind = [ ", escape" ];
                };
              }
            ]
          '';
        };
      };
    };
  }
