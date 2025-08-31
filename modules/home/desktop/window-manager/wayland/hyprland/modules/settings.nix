{
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) types mkOption;
  inherit (lib.${namespace}) mkStrOpt mkPackageOpt;
in {
  settingsModule = types.submodule {
    options = {
      modifyer = mkOption {
        type = types.submodule {
          options = {
            mainMod = mkStrOpt "SUPER" "The main modifyer";
            mainModCtrl = mkStrOpt "SUPER_CONTROL" "The main modifyer + Control";
            mainModShift = mkStrOpt "SUPER_SHIFT" "The main modifyer + Shift";
          };
        };
        default = {};
      };
      defaultPrograms = mkOption {
        type = types.submodule {
          options = {
            terminal = mkPackageOpt pkgs.wezterm "The default terminal to use";
            browser = mkPackageOpt pkgs.firefox "The browser to use";
            launcher = mkPackageOpt pkgs.yofi "The default launcher to use";
            secondaryLauncher = mkPackageOpt pkgs.anyrun "The secondary launcher to use";
            explorer = mkPackageOpt pkgs.nemo "The default explorer to use";
            screenLocker = mkPackageOpt pkgs.hyprlock "The default screen locker";
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
