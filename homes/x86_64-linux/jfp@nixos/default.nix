{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  JenSeReal = {
    desktop = {
      # environment.sway = enabled;
      environment.hyprland = enabled;
    };
    programs = {
      cli = {
        git = enabled;
        ssh = {
          enable = true;
          includes = ["${config.home.homeDirectory}/.ssh/hosts/jfp.one"];
        };
        direnv = enabled;
      };

      shells = {
        fish = enabled;
        nushell = enabled;
        addons.starship = enabled;
      };

      gui.terminal-emulators.kitty = enabled;
      gui.terminal-emulators.wezterm = enabled;
      gui.ide.vscode = enabled;
      gui.ide.zed = enabled;
    };
    security.sops = enabled;
    theming.stylix = enabled;
  };

  sops.secrets."ssh/jfp.one" = {
    sopsFile = ./secrets/ssh.yml;
    path = "${config.home.homeDirectory}/.ssh/hosts/jfp.one";
  };

  nix.extraOptions = "";
}
