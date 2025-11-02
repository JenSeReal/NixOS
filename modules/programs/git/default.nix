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
    };

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [
      bfg-repo-cleaner
      git
      git-crypt
      git-filter-repo
      git-lfs
      gitleaks
      gitlint
    ];
  };

  home.ifEnabled = {cfg, ...}: {
    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      inherit (cfg) userName userEmail includes;
      lfs.enable = true;
      delta.enable = true;
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
          directory = "${homeconfig.home.homeDirectory}/dev";
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

    programs.gh.enable = true;
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [
      bfg-repo-cleaner
      git
      git-crypt
      git-filter-repo
      git-lfs
      gitleaks
      gitlint
    ];
  };
}
