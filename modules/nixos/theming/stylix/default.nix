{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  # material-palenight tokyo-night-terminal-storm
  # theme = "tokyo-night-terminal-storm";
  opacity = 0.95;
  font-size = 11;

  cfg = config.${namespace}.theming.stylix;
in {
  options.${namespace}.theming.stylix = {
    enable = mkEnableOption "Whether or not to enable stylix theming.";
  };

  config = mkIf cfg.enable {
    # stylix.enable = true;
    # stylix.image = ./2.jpg;
    # stylix.polarity = "dark";
    # # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
    # stylix.base16Scheme = ./synthwave84.yaml;

    # stylix.opacity = {
    #   terminal = opacity;
    #   popups = opacity;
    # };

    # # stylix.cursor = with pkgs; {
    # #   package = phinger-cursors;
    # #   name = "phinger-cursors-light";
    # #   size = 24;
    # # };

    # stylix.cursor = {
    #   package = pkgs.${namespace}.layan-cursors;
    #   name = "layan-white-cursors";
    #   size = 24;
    # };

    # stylix.fonts = with pkgs; {
    #   serif = {
    #     package = noto-fonts-cjk-sans;
    #     name = "Noto Sans CJK JP";
    #   };

    #   sansSerif = {
    #     package = noto-fonts-cjk-sans;
    #     name = "Noto Sans CJK JP";
    #   };

    #   # monospace = {
    #   #   package = maple-mono;
    #   #   name = "Maple Mono";
    #   # };

    #   emoji = {
    #     package = noto-fonts-emoji;
    #     name = "Noto Color Emoji";
    #   };

    #   sizes = {
    #     applications = font-size;
    #     desktop = font-size;
    #     popups = font-size;
    #     terminal = font-size;
    #   };
    # };
  };
}
