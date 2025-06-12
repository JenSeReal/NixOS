{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  inherit
    (lib.types)
    listOf
    str
    attrsOf
    ints
    coercedTo
    submodule
    bool
    ;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.programs.cli.homebrew;
in {
  options.${namespace}.programs.cli.homebrew = {
    enable = mkEnableOption "Wether to enable homebrew.";

    additional_taps = mkOpt (listOf str) [] "A list of additional taps to install";
    additional_brews = mkOpt (listOf str) [] "A list of additional brews to install";
    additional_casks = mkOpt (listOf (
      coercedTo str
      (name: {
        inherit name;
        args = {};
      })
      (submodule {
        options = {
          name = mkOption {
            type = str;
            description = "Name of the cask to install";
          };
          args = mkOption {
            type = submodule {
              options = {
                no_quarantine = mkOption {
                  type = bool;
                  default = false;
                  description = "Whether to disable quarantine for the cask";
                };
              };
            };
            default = {};
            description = "Arguments for the cask installation";
          };
        };
      })
    )) [] "List of Homebrew casks to install";
    additional_mas_apps = mkOpt (attrsOf ints.positive) {} "A list of additional mas to install";
  };

  config = mkIf cfg.enable {
    nix-homebrew = {
      enable = true;
      user = config.JenSeReal.user.name;
    };

    homebrew = {
      enable = true;
      # caskArgs.require_sha = true;

      onActivation = {
        autoUpdate = true;
        upgrade = true;
        cleanup = "zap";
      };

      masApps = {} // cfg.additional_mas_apps;

      taps = [] ++ cfg.additional_taps;

      brews = [] ++ cfg.additional_brews;

      casks =
        [
          "steam"
          "headlamp"
          "mattermost"
        ]
        ++ cfg.additional_casks;
    };
  };
}
