{
  delib,
  pkgs,
  ...
}: let
  default = with pkgs; [
    cascadia-code
    google-fonts

    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.meslo-lg
    nerd-fonts.monaspace
    nerd-fonts.symbols-only

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji

    fira-code
    fira-code-symbols

    dejavu_fonts
    line-awesome
  ];
in
  delib.module {
    name = "settings.fonts";

    options = with delib;
      moduleOptions {
        enable = boolOption false;
        additionalFonts = listOfOption package [];
      };

    darwin.ifEnabled = {cfg, ...}: {
      fonts.packages = default ++ [pkgs.sketchybar-app-font] ++ cfg.additionalFonts;

      system = {
        defaults = {
          NSGlobalDomain = {
            AppleFontSmoothing = 1;
          };
        };
      };
    };

    nixos.ifEnabled = {cfg, ...}: {
      environment.variables = {
        LOG_ICONS = "true";
      };
      fonts.packages = default ++ cfg.additionalFonts;
    };
  }
