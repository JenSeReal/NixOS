{lib, ...}: let
  inherit (lib) types mkOption;

  submapModule = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = "Name of the submap";
        example = "🎥 Recorder";
      };

      trigger = mkOption {
        type = types.str;
        description = "Keybinding that activates the submap";
        example = "\${mainMod}, R";
      };

      actions = mkOption {
        type = with types; attrsOf (listOf str);
        description = "Set of action types and their bindings";
        example = lib.literalExpression ''
          {
            bind = [
              "s, exec, ''${toggle} ''${screen-recorder} -s"
              "w, exec, ''${toggle} ''${screen-recorder} -w"
            ];
            bindm = [
              "SUPER, mouse:272, movewindow"
            ];
          }
        '';
      };

      exit = mkOption {
        type = types.submodule {
          options = {
            bind = mkOption {
              type = with types; listOf str;
              description = "Exit bindings to reset the submap";
              default = [", escape"];
              example = [
                ", escape"
                "q, exec, notify-send 'Exited submap'"
              ];
            };
          };
        };
        description = "Exit bindings for the submap";
        default = {
          bind = [", escape"];
        };
      };
    };
  };
in {
  inherit submapModule;
}
