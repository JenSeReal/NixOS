{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkPackageOption
    getExe'
    types
    ;

  inherit (lib.${namespace}) filterNulls;

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

  watcherModule = types.submodule {
    options = {
      enable_clipboard = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Enable watching the X11/Wayland clipboard selection";
      };

      enable_primary = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Enable watching the X11/Wayland primary selection";
      };

      enable_secondary = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Enable watching the X11/Wayland primary selection";
      };

      sensitive_mime_types = lib.mkOption {
        type = types.listOf types.str;
        default = [ "x-kde-passwordManagerHint" ];
        description = "Ignore clips that match any of the MIME types.";
      };

      filter_text_min_length = lib.mkOption {
        type = types.int;
        default = 1;
        description = "Ignore text clips with a length less than or equal to `filter_text_min_length`, in characters (Unicode scalar value), not bytes.";
      };

      filter_text_max_length = lib.mkOption {
        type = types.int;
        default = 20000000;
        description = "Ignore text clips with a length greater than `filter_text_max_length`, in characters (Unicode scalar value), not bytes.";
      };

      denied_text_regex_patterns = lib.mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          Ignore text clips that match any of the provided regular expressions.
          The regular expression engine is powered by https://github.com/rust-lang/regex
        '';
      };

      capture_image = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Enable or disable capturing images.";
      };

      filter_image_max_size = lib.mkOption {
        type = types.int;
        default = 5242880;
        description = "Ignore image clips with a size greater than `filter_image_max_size`, in bytes.";
      };
    };
  };

  grpcModule = types.submodule {
    options = {
      enable_http = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Enable HTTP";
      };

      enable_local_socket = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Enable local socket";
      };

      host = lib.mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Host";
      };

      port = lib.mkOption {
        type = types.int;
        default = 45045;
        description = "Port";
      };

      local_socket = lib.mkOption {
        type = types.str;
        default = "/run/user/1000/clipcat/grpc.sock";
        description = "Local socket";
      };
    };
  };

  dbusModule = types.submodule {
    options = {
      enable = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Enable dbus";
      };

      instance = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Specify the identifier for the current `clipcat` instance.
          The D-Bus service name will appear as "org.clipcat.clipcat.instance-0".
          If the identifier is not provided, the D-Bus service name will appear as "org.clipcat.clipcat"
        '';
      };
    };
  };

  metricModule = types.submodule {
    options = {
      enable = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Enable metrics";
      };

      host = lib.mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Host";
      };

      port = lib.mkOption {
        type = types.int;
        default = 45047;
        description = "Port";
      };
    };
  };

  desktopNotificationModule = types.submodule {
    options = {
      enable = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Enable dbus";
      };

      icon = lib.mkOption {
        type = types.str;
        default = "accessories-clipboard";
        description = "The icon shown in the notification";
      };

      timeout_ms = lib.mkOption {
        type = types.int;
        default = 2000;
        description = "Timeout in milliseconds.";
      };

      long_plaintext_length = lib.mkOption {
        type = types.int;
        default = 2000;
        description = "?";
      };
    };
  };

  snippetModule = types.submodule {
    options = {
      type = lib.mkOption {
        type = types.enum [
          "Directory"
          "File"
          "Text"
        ];
        description = "Type of snippet";
      };
      name = lib.mkOption {
        type = types.str;
        description = "Name of snippet";
      };
      path = lib.mkOption {
        type = types.str;
        description = "Path to file or directory for File/Directory snippets";
      };
      content = lib.mkOption {
        type = types.str;
        description = "Content for Text snippets";
      };
    };
  };

  settingsModule = types.submodule {
    options = {
      pid_file = lib.mkOption {
        type = types.str;
        default = "/run/user/1000/clipcatd.pid";
        description = "Where the pid file will reside";
      };

      primary_threshold_ms = lib.mkOption {
        type = types.int;
        default = 5000;
        description = "Controls how often the program updates its stored value of the Linux primary selection";
      };

      max_history = lib.mkOption {
        type = types.int;
        default = 50;
        description = "Maximum number of clips in history";
      };

      synchronize_selection_with_clipboard = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Emit logs to journald.";
      };

      history_file_path = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "The history file path";
      };

      snippets = lib.mkOption {
        type = types.listOf snippetModule;
        default = [ ];
        description = "List of snippets";
      };

      log = lib.mkOption {
        type = logModule;
        default = { };
        description = "Logging options";
      };

      watcher = lib.mkOption {
        type = watcherModule;
        default = { };
        description = "Watcher options";
      };

      grpc = lib.mkOption {
        type = grpcModule;
        default = { };
        description = "grpc options";
      };

      dbus = lib.mkOption {
        type = dbusModule;
        default = { };
        description = "dbus options";
      };

      metric = lib.mkOption {
        type = metricModule;
        default = { };
        description = "metrics options";
      };

      desktop_notification = lib.mkOption {
        type = desktopNotificationModule;
        default = { };
        description = "desktop notification module";
      };
    };
  };

  cfg = config.${namespace}.services.desktop.clipboard-managers.clipcatd;
in
{
  options.${namespace}.services.desktop.clipboard-managers.clipcatd = {
    enable = mkEnableOption "clipcatd";
    package = mkPackageOption pkgs "clipcat" { };
    settings = lib.mkOption {
      type = settingsModule;
      description = "Configuration settings of clipcatd";
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file.".config/clipcat/clipcatd.toml".source =
      (pkgs.formats.toml { }).generate "clipcatclt.toml"
        (filterNulls ({ daemonize = false; } // cfg.settings));

    systemd.user.services.clipcatd = {
      Unit = {
        Description = "Clipcat Daemon";
        PartOf = [ "graphical-session.target" ];
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Service = {
        ExecStartPre = "${getExe' pkgs.coreutils "rm"} -f ${cfg.settings.pid_file}";
        ExecStart = "${getExe' cfg.package "clipcatd"} --no-daemon --replace";
        Restart = "on-failure";
        Type = "simple";
      };
    };
  };
}
