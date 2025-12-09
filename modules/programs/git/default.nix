{
  delib,
  pkgs,
  homeconfig,
  ...
}:
delib.module {
  name = "programs.git";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      includes = listOfOption attrs [];
      userName = strOption "JenSeReal";
      userEmail = strOption "jens@plueddemann.de";
      signByDefault = boolOption true;
      signingKey = strOption "${homeconfig.home.homeDirectory}/.ssh/id_ed25519";
      enablePreCommit = boolOption true;
      enableGitui = boolOption true;
    };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = with pkgs; [
      bfg-repo-cleaner
      git
      git-crypt
      git-filter-repo
      git-lfs
      gitleaks
      gitlint
    ] ++ (if cfg.enablePreCommit then [pre-commit] else [])
      ++ (if cfg.enableGitui then [gitui] else []);
  };

  home.ifEnabled = {cfg, ...}: {
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };

    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      inherit (cfg) includes;
      lfs.enable = true;
      signing = {
        key = cfg.signingKey;
        inherit (cfg) signByDefault;
      };
      settings = {
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
          directory = "${homeconfig.home.homeDirectory}/dev";
        };
        gpg = {
          format = "ssh";
        };
        user = {
          email = cfg.userEmail;
          name = cfg.userName;
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

    programs.gh.enable = true;
    programs.gitui.enable = cfg.enableGitui;
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = with pkgs; [
      bfg-repo-cleaner
      git
      git-crypt
      git-filter-repo
      git-lfs
      gitleaks
      gitlint
    ] ++ (if cfg.enablePreCommit then [pre-commit] else [])
      ++ (if cfg.enableGitui then [gitui] else []);
  };
}
