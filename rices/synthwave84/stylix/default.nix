{
  delib,
  inputs,
  pkgs,
  ...
}:
delib.rice {
  name = "synthwave84";

  nixos = {
    imports = [inputs.stylix.nixosModules.stylix];

    stylix = {
      enable = true;
      base16Scheme = ./base16Scheme.yaml;
      image = ./P13_Background1.png;
      polarity = "dark";
      homeManagerIntegration.autoImport = false;
    };
  };

  home = {
    imports = [inputs.stylix.homeModules.stylix];

    stylix = {
      enable = true;
      polarity = "dark";
      image = ./P13_Background1.png;
      base16Scheme = ./base16Scheme.yaml;
      targets.firefox.profileNames = ["default"];

      cursor = {
        package = pkgs.layan-cursors;
        name = "layan-white-cursors";
        size = 24;
      };

      fonts = {
        sizes = {
          desktop = 11;
          applications = 12;
          terminal = 13;
          popups = 12;
        };

        serif = {
          package = pkgs.monaspace;
          name =
            if pkgs.stdenv.hostPlatform.isDarwin
            then "Monaspace Neon"
            else "MonaspaceNeon";
        };
        sansSerif = {
          package = pkgs.monaspace;
          name =
            if pkgs.stdenv.hostPlatform.isDarwin
            then "Monaspace Neon"
            else "MonaspaceNeon";
        };
        monospace = {
          package = pkgs.monaspace;
          name =
            if pkgs.stdenv.hostPlatform.isDarwin
            then "Monaspace Krypton"
            else "MonaspaceKrypton";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
    };
  };
}
