{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "programs.kitty";
  options = delib.singleEnableOption false;

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [kitty];
  };

  home.ifEnabled = {...}: {
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
      font.name = lib.mkDefault "Fira Code";
      font.package = lib.mkDefault pkgs.fira-code;
      font.size = lib.mkDefault 12;
    };
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [kitty];
  };
}
