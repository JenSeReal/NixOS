{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf mkDefault;

  cfg = config.JenSeReal.programs.gui.terminal-emulators.kitty;
in
{
  options.JenSeReal.programs.gui.terminal-emulators.kitty = {
    enable = mkEnableOption "Whether or not to add kitty.";
  };

  config = mkIf cfg.enable {
    xdg.configFile."kitty/current-theme.conf".source = ./themes/synthwave84.conf;
    programs.kitty = {
      enable = true;
      settings = {
        cursor_shape = "beam";
        cursor_shape_unfocused = "hollow";
        confirm_os_window_close = 0;
        scrollback_lines = 10000;
        disable_ligatures = "cursor";

        include = "./current-theme.conf";
      };
      font.name = mkDefault "Fira Code";
      font.package = mkDefault pkgs.fira-code;
      font.size = mkDefault 12;
    };
  };
}
