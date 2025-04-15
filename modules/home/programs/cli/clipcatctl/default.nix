{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    types
    ;

  settingsModule = types.submodule {
    options = {
      server_endpoint = mkOption {
        type = types.str;
        description = "Path to the clipcatctl gRPC socket.";
      };

      preview_length = mkOption {
        type = types.int;
        description = "Number of characters to show in preview.";
      };

      log = mkOption {
        type = logOptionType;
      };
    };
  };

  cfg = config.JenSeReal.programs.clipcatctl;

  logOptionType = types.submodule {
    options = {
      emit_journald = mkOption {
        type = types.bool;
        description = "Emit logs to journald.";
      };
      emit_stdout = mkOption {
        type = types.bool;
        description = "Emit logs to stdout.";
      };
      emit_stderr = mkOption {
        type = types.bool;
        description = "Emit logs to stderr.";
      };
      level = mkOption {
        type = types.enum [
          "DEBUG"
          "INFO"
          "WARN"
          "ERROR"
        ];
        description = "Logging level.";
      };
    };
  };

in
{
  options.JenSeReal.programs.clipcatctl = {
    enable = mkEnableOption "Enable clipcatctl support.";
    package = mkPackageOption pkgs "clipcat" { };

    settings = mkOption {
      type = settingsModule;
      default = {
        server_endpoint = "/run/user/1000/clipcat/grpc.sock";
        preview_length = 100;
        log = {
          emit_journald = true;
          emit_stdout = false;
          emit_stderr = false;
          level = "INFO";
        };
      };

      description = "Configuration settings for clipcatctl, written to clipcatclt.toml";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file.".config/clipcat/clipcatclt.toml".source =
      (pkgs.formats.toml { }).generate "clipcatclt.toml"
        cfg.settings;
  };
}
