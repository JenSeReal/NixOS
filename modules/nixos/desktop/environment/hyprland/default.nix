{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf getExe;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.desktop.environment.hyprland;
in
{
  options.${namespace}.desktop.environment.hyprland = {
    enable = mkEnableOption "Whether or not to enable sway window manager.";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      desktop = {
        window-manager.wayland.hyprland = enabled;
        display-manager.tuigreet = {
          enable = true;
          autoLogin = "jfp";
          defaultSession = getExe pkgs.hyprland;
        };
        bars.waybar.enable = true;
        launchers.kickoff.enable = true;
        notifications.mako.enable = true;
        portals.xdg.enable = true;
        logout-menu.wlogout.enable = true;
        screen-locker.swaylock-effects.enable = true;
        libraries.qt.enable = true;
        layout-manager = {
          kanshi.enable = true;
          way-displays.enable = true;
          wlr-randr.enable = true;
        };

      };
      hardware.audio.pipewire.enable = true;
      suites.wlroots.enable = true;
      security = {
        keyring.enable = true;
        polkit.enable = true;
        bitwarden.enable = true;
      };
      gui = {
        # browser.firefox.enable = true;
        file-manager.nemo.enable = true;
      };
      theming.stylix.enable = true;

    };

    environment.systemPackages = with pkgs; [
      pciutils
      kitty
      swayosd
      grim
      slurp
      wl-clipboard
      mako
      kanshi
      nwg-displays
    ];
  };
}
