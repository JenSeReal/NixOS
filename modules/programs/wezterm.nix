{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "programs.wezterm";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.wezterm;
    };

  home.ifEnabled = {cfg, ...}: {
    programs.wezterm = {
      enable = true;
      package = cfg.package;
      extraConfig = ''
        ${
          if pkgs.stdenv.isDarwin
          then ''
            -- Fix option key being broken
            config.send_composed_key_when_left_alt_is_pressed = true

            -- Use nu by default
            config.default_prog = { 'zsh', '-c', '${lib.getExe pkgs.nushell}' }
          ''
          else ""
        }
        config.color_scheme = 'Synthwave84'

        -- URL highlight color
        config.hyperlink_rules = {
          {
            regex = "\\b\\w+://[\\w.-]+\\S*\\b",
            format = "$0",
          },
        }

        -- Window and Tab settings
        config.enable_tab_bar = true
        config.hide_tab_bar_if_only_one_tab = true
        config.window_padding = {
          left = 10,
          right = 10,
          top = 10,
          bottom = 10,
        }
        config.window_background_opacity = 1.0
        config.text_background_opacity = 1.0
        config.inactive_pane_hsb = {
          saturation = 0.9,
          brightness = 0.7,
        }
        config.default_cursor_style = 'SteadyBar'
        config.check_for_updates = false
        config.window_close_confirmation = 'NeverPrompt'

        return config
      '';
    };
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
