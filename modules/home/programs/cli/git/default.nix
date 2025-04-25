{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.types)
    listOf
    attrs
    str
    bool
    ;
  inherit (lib.${namespace}) mkOpt enabled;

  user = config.JenSeReal.user;

  cfg = config.JenSeReal.programs.cli.git;
in
{
  options.JenSeReal.programs.cli.git = {
    enable = mkEnableOption "Whether or not to install and configure git.";
    includes = mkOpt (listOf attrs) [ ] "Git includeIf paths and conditions.";
    userName = mkOpt str user.fullName "The name to configure git with.";
    userEmail = mkOpt str user.email "The email to configure git with.";
    signByDefault = mkOpt bool true "Whether to sign commits by default";
    signingKey =
      mkOpt str "${config.home.homeDirectory}/.ssh/id_ed25519"
        "The key ID to sign commits with.";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      inherit (cfg) userName userEmail includes;
      lfs = enabled;
      delta = enabled;
      signing = {
        key = cfg.signingKey;
        inherit (cfg) signByDefault;
      };
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        pull = {
          rebase = true;
        };
        push = {
          autoSetupRemote = true;
        };
        core = {
          whitespace = "trailing-space,space-before-tab";
        };
        rebase = {
          autoStash = true;
        };
        fetch = {
          prune = true;
        };
        safe = {
          directory = "${config.home.homeDirectory}/dev";
        };
        gpg = {
          format = "ssh";
        };
      };
      ignores = [
        ".DS_Store"
        "Desktop.ini"

        # Thumbnail cache files
        "._*"
        "Thumbs.db"

        # Files that might appear on external disks
        ".Spotlight-V100"
        ".Trashes"

        # Compiled Python files
        "*.pyc"

        # Compiled C++ files
        "*.out"

        # Application specific files
        "venv"
        "node_modules"
        ".sass-cache"

        ".idea*"

        "target"

        ".direnv"
        ".devenv"
        ".envrc"
      ];
    };

    programs.gh = enabled;
  };
}
