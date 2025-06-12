{
  config,
  lib,
  namespace,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled;
  is-darwin = pkgs.stdenv.isDarwin;
in
{
  imports = [ inputs.ragenix.homeManagerModules.default ];

  age.secrets.ssh-config-jfp-one = {
    file = ./secrets/ssh-config-jfp-one.age;
    path = "${config.home.homeDirectory}/.ssh/includes/ssh-config-jfp-one";
  };

  age.secrets.git-config-include-identity-nt = {
    file = ./secrets/git-config-include-identity-nt.age;
    path = "${config.home.homeDirectory}/.config/git/includes/gitconfig-include-identity-nt";
  };

  age.secrets.git-config-include-identity-mb = {
    file = ./secrets/git-config-include-identity-mb.age;
    path = "${config.home.homeDirectory}/.config/git/includes/gitconfig-include-identity-mb";
  };

  programs.zsh = {
    enable = true;

    initContent = mkIf is-darwin ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
      export PATH="/Users/jpl/.rd/bin:$PATH"
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "thefuck"
      ];
    };
  };

  JenSeReal = {
    services.desktop.window-managers.aerospace = enabled;
    programs = {
      cli = {
        bat = enabled;
        direnv = enabled;
        eza = enabled;
        fzf = enabled;
        git = {
          enable = true;
          includes = [
            {
              path = config.age.secrets.git-config-include-identity-mb.path;
              condition = "hasconfig:remote.*.url:git@git.i.mercedes-benz.com:*/**";
            }
            {
              path = config.age.secrets.git-config-include-identity-nt.path;
              condition = "hasconfig:remote.*.url:git@github.com:novatecconsulting/**";
            }
          ];
        };
        nh = enabled;
        ripgrep = enabled;
        ssh = {
          enable = true;
          includes = [ (lib.removePrefix ".ssh/" config.age.secrets.ssh-config-jfp-one.path) ];
        };
        thefuck = enabled;
        zoxide = enabled;
      };

      gui = {
        ide.vscode = enabled;
        terminal-emulators.wezterm = enabled;
      };

      firefox = enabled;

      tui.nvim = enabled;

      shells = {
        nushell = enabled;
        fish = enabled;
        addons.starship = enabled;
        addons.carapace = enabled;
      };
    };

    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };
  };

  home.stateVersion = "24.05";
}
