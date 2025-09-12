{
  delib,
  pkgs,
  inputs,
  ...
}: let
  common.stylix = {
    enable = true;
    image = ./P13_Background1.png;
    # base16Scheme = ./base16Scheme.yaml;
    polarity = "dark";
  };
in
  delib.rice {
    name = "synthwave84";

    # darwin =
    #   common
    #   // {
    #     imports = [inputs.stylix.darwinModules.stylix];
    #   };

    # home =
    #   common
    #   // {
    #     imports = [inputs.stylix.homeModules.stylix];
    #     stylix = {
    #       cursor = {
    #         package = pkgs.layan-cursors;
    #         name = "layan-white-cursors";
    #         size = 24;
    #       };

    #       opacity = {
    #         desktop = 1.0;
    #         applications = 0.90;
    #         terminal = 0.90;
    #         popups = 1.0;
    #       };

    #       # cursor = with pkgs; {
    #       #   package = phinger-cursors;
    #       #   name = "phinger-cursors-light";
    #       #   size = 24;
    #       # };

    #       fonts = with pkgs; {
    #         sizes = {
    #           desktop = 11;
    #           applications = 12;
    #           terminal = 13;
    #           popups = 12;
    #         };

    #         serif = {
    #           package = monaspace;
    #           name =
    #             if stdenv.hostPlatform.isDarwin
    #             then "Monaspace Xenon"
    #             else "Monaspace Xenon";
    #         };
    #         sansSerif = {
    #           package = monaspace;
    #           name =
    #             if stdenv.hostPlatform.isDarwin
    #             then "Monaspace Argon"
    #             else "Monaspace Argon";
    #         };
    #         monospace = {
    #           package = monaspace;
    #           name =
    #             if pkgs.stdenv.hostPlatform.isDarwin
    #             then "Monaspace Krypton"
    #             else "Monaspace Krypton";
    #         };
    #         emoji = {
    #           package = noto-fonts-color-emoji;
    #           name = "Noto Color Emoji";
    #         };
    #       };

    #       targets = {
    #         vscode.profileNames = ["stylix"];
    #         firefox.profileNames = ["stylix"];
    #       };
    #     };
    #   };

    # nixos =
    #   common
    #   // {
    #     imports = [inputs.stylix.nixosModules.stylix];
    #   };
  }
