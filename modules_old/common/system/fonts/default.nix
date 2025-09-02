{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.types) listOf package;
  inherit (lib.${namespace}) mkOpt;

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

  cfg = config.JenSeReal.system.fonts;
in {
  options.JenSeReal.system.fonts = {
    enable = mkEnableOption "Whether or not to manage fonts.";
    additionalFonts = mkOpt (listOf package) [] "Custom font packages to install.";
  };

  config = mkIf cfg.enable {
    environment.variables = {
      LOG_ICONS = "true";
    };
    fonts.packages = default ++ cfg.additionalFonts;
  };
}
