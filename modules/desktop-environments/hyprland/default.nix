{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "desktop-environments.hyprland";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    myconfig = {
      communication.discord.enable = true;
      programs = {
        desktop.screen-lockers.hyprlock.enable = true;
      };
      services = {
        desktop.idle-managers.hypridle.enable = true;
      };
      desktop = {
        window-manager.wayland.hyprland.enable = true;
        display-manager.tuigreet = {
          enable = true;
          autoLogin = "jfp";
          defaultSession = lib.getExe pkgs.hyprland;
        };
        bars.waybar.enable = true;
        launchers.kickoff.enable = true;
        notifications.mako.enable = true;
        portals.xdg.enable = true;
        logout-menu.wlogout.enable = true;
        # screen-locker.swaylock-effects.enable = true;
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
      # themes.stylix.enable = true;
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
