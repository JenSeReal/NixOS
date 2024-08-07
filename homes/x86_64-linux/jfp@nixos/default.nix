{ lib, config, ... }:
with lib;
with lib.JenSeReal;
{
  JenSeReal = {
    desktop = {
      environment.sway = enabled;
    };
    programs = {
      cli = {
        git = enabled;
        ssh = {
          enable = true;
          includes = [ "${config.home.homeDirectory}/.ssh/hosts/jfp.one" ];
        };
        direnv = enabled;
      };

      gui.terminal-emulator.kitty = enabled;
      gui.terminal-emulator.wezterm = enabled;
      gui.ide.vscode = enabled;
    };
    security.sops = enabled;
    system.shells = {
      fish = enabled;
      nushell = enabled;
      addons.starship = enabled;
    };
  };

  sops.secrets."ssh/jfp.one" = {
    sopsFile = ./secrets/ssh.yml;
    path = "${config.home.homeDirectory}/.ssh/hosts/jfp.one";
  };

  nix.extraOptions = "";
}
