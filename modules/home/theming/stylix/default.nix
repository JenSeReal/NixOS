{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.theming.stylix;
in {
  options.${namespace}.theming.stylix = {
    enable = mkEnableOption "Whether or not to enable stylix theming.";
  };

  config = mkIf cfg.enable {
    # stylix.enable = true;
    # stylix.image = ./P13_Background1.png;
    # stylix.polarity = "dark";
    # stylix.base16Scheme = ./synthwave84.yaml;

    # # stylix.cursor = with pkgs; {
    # #   package = phinger-cursors;
    # #   name = "phinger-cursors-light";
    # #   size = 32;
    # # };

    # stylix.cursor = {
    #   package = pkgs.${namespace}.layan-cursors;
    #   name = "layan-white-cursors";
    #   size = 24;
    # };

    # # stylix.fonts.monospace = with pkgs; {
    # # name = "Fira Code";
    # # package = fira-code;
    # # };

    # stylix.targets.vscode.enable = false;
  };
}
