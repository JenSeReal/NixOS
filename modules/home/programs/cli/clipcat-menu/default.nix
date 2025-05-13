{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  inherit (lib.${namespace}) filterNulls mkPackageOpt';

  logModule = types.submodule {
    options = {
      file_path = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Emit log messages to a log file.
          If this value is omitted, `clipcatd` will disable logging to a file.
        '';
      };

      emit_journald = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Emit logs to journald.";
      };

      emit_stdout = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Emit logs to stdout.";
      };

      emit_stderr = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Emit logs to stderr.";
      };

      level = lib.mkOption {
        type = types.enum [
          "DEBUG"
          "INFO"
          "WARN"
          "ERROR"
        ];
        default = "INFO";
        description = "Logging level.";
      };
    };
  };

  menuModule = types.submodule {
    options = {
      line_length = mkOption { type = types.int; };
      menu_length = mkOption { type = types.int; };
      menu_prompt = mkOption { type = types.str; };
      extra_arguments = mkOption { type = types.listOf types.str; };
    };
  };

  settingsModule = types.submodule {
    options = {
      server_endpoint = mkOption {
        type = types.str;
        default = "/run/user/1000/clipcat/grpc.sock";
      };

      finder = mkOption {
        type = types.str;
        default = "rofi";
      };

      preview_length = mkOption {
        type = types.int;
        default = 80;
      };

      rofi = mkOption {
        type = menuModule;
        default = {
          line_length = 100;
          menu_length = 30;
          menu_prompt = "Clipcat";
          extra_arguments = [ ];
        };
      };

      dmenu = mkOption {
        type = menuModule;
        default = {
          line_length = 100;
          menu_length = 30;
          menu_prompt = "Clipcat";
          extra_arguments = [ ];
        };
      };

      choose = mkOption {
        type = menuModule;
        default = {
          line_length = 100;
          menu_length = 30;
          menu_prompt = "Clipcat";
          extra_arguments = [ ];
        };
      };

      custom_finder = mkOption {
        type = types.submodule {
          options = {
            program = mkOption {
              type = types.str;
              default = "fzf";
            };
            args = mkOption {
              type = types.listOf types.str;
              default = [ ];
            };
          };
        };
        default = { };
      };

      log = mkOption {
        type = logModule;
        default = { };
      };
    };
  };

  cfg = config.JenSeReal.programs.clipcat-menu;
in
{
  options.JenSeReal.programs.clipcat-menu = {
    enable = mkEnableOption "Enable clipcat-menu integration.";
    package = mkPackageOpt' pkgs.clipcat;

    settings = mkOption {
      type = settingsModule;
      description = "Configuration settings for clipcat-menu (used to generate clipcatclt.toml).";
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
      pkgs.skim
    ];

    home.file.".config/clipcat/clipcat-menu.toml".source =
      (pkgs.formats.toml { }).generate "clipcat-menu.toml"
        (filterNulls cfg.settings);
  };
}
