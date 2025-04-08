{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption getExe;

  cfg = config.JenSeReal.programs.gui.terminal-emulators.wezterm;
in
{
  options.JenSeReal.programs.gui.terminal-emulators.wezterm = {
    enable = mkEnableOption "Whether or not to add wezterm.";
  };

  # TODO: colors are not there yet
  config = mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      # package = inputs.wezterm.packages.${pkgs.system}.default;
      colorSchemes = {
        Synthwave84 = {
          foreground = "#ffffff";
          background = "#2b213a";
          cursor_bg = "#ffffff";
          cursor_border = "#ffffff";
          cursor_fg = "#2b213a";
          selection_bg = "#5a5a5a";
          selection_fg = "none";
          ansi = [
            "#2b213a"
            "#ff5370"
            "#29d398"
            "#ffd866"
            "#02EDF9"
            "#FF7DDA"
            "#02EDF9"
            "#ffffff"
          ];
          brights = [
            "#755390"
            "#ff637f"
            "#3FDAA4"
            "#ffeb85"
            "#3FC4DE"
            "#F075B7"
            "#6BE4E6"
            "#f8f8f2"
          ];
          scrollbar_thumb = "#5a5a5a";
          split = "#5a5a5a";
          tab_bar = {
            background = "#2b213a";
            active_tab = {
              bg_color = "#ff5370";
              fg_color = "#ffffff";
            };
            inactive_tab = {
              bg_color = "#2b213a";
              fg_color = "#755390";
            };
            inactive_tab_hover = {
              bg_color = "#2b213a";
              fg_color = "#755390";
            };
            new_tab = {
              bg_color = "#2b213a";
              fg_color = "#ffffff";
            };
            new_tab_hover = {
              bg_color = "#2b213a";
              fg_color = "#ffffff";
              italic = true;
            };
          };
        };
      };
      extraConfig = ''
        -- This will hold the configuration.
        local config = wezterm.config_builder()

        ${
          if pkgs.stdenv.isDarwin then
            ''
              -- Fix option key being broken
              config.send_composed_key_when_left_alt_is_pressed = true

              -- Use nu by default
              config.default_prog = { 'zsh', '-c', '${getExe config.programs.nushell.package}' }
            ''
          else
            ""
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
}
