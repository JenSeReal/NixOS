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
    stylix = {
      enable = true;
      image = ./P13_Background1.png;
      polarity = "dark";
      base16Scheme = ./synthwave84.yaml;

      cursor = {
        package = pkgs.${namespace}.layan-cursors;
        name = "layan-white-cursors";
        size = 24;
      };

      opacity = {
        desktop = 1.0;
        applications = 0.90;
        terminal = 0.90;
        popups = 1.0;
      };

      # cursor = with pkgs; {
      #   package = phinger-cursors;
      #   name = "phinger-cursors-light";
      #   size = 24;
      # };

      fonts = with pkgs; {
        sizes = {
          desktop = 11;
          applications = 12;
          terminal = 13;
          popups = 12;
        };

        serif = {
          package = monaspace;
          name =
            if stdenv.hostPlatform.isDarwin
            then "Monaspace Xenon"
            else "MonaspaceXenon";
        };
        sansSerif = {
          package = monaspace;
          name =
            if stdenv.hostPlatform.isDarwin
            then "Monaspace Argon"
            else "MonaspaceArgon";
        };
        monospace = {
          package = monaspace;
          name =
            if pkgs.stdenv.hostPlatform.isDarwin
            then "Monaspace Krypton"
            else "MonaspaceKrypton";
        };
        emoji = {
          package = noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };

      targets = {
        vscode = {
          enable = true;
          profileNames = ["stylix"];
        };
      };
    };
  };
}
