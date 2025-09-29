# plymouth = lib.mkIf cfg.secureBoot {
#   enable = true;
#   # theme = "catppuccin-macchiato";
#   # themePackages = [ pkgs.catppuccin-plymouth ];
# };
{
  delib,
  lib,
  ...
}:
delib.module {
  name = "boot";

  nixos.ifEnabled = {cfg, ...}: {
    boot.plymouth = lib.mkIf cfg.secureBoot {
      # theme = "catppuccin-macchiato";
      # themePackages = [ pkgs.catppuccin-plymouth ];
    };
  };
}
