{delib, ...}:
delib.rice {
  name = "synthwave84";

  nixos = {
    boot.plymouth = {
      # theme = "catppuccin-macchiato";
      # themePackages = [ pkgs.catppuccin-plymouth ];
    };
  };
}
