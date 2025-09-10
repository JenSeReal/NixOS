{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "desktop-environments.sway";
  options = delib.singleEnableOption false;

  home.ifEnabled = {myconfig, ...}: {
    myconfig = {
      programs.desktop.screen-lockers.swaylock.enable = true;
      desktop = {
        window-manager.wayland.sway.enable = true;
        bars.waybar.enable = true;
        layout-manager.kanshi.enable = true;
        service.swayidle.enable = true;
        wallpaper.swww.enable = true;
      };
    };
  };

  nixos.ifEnabled = {
    myconfig.desktop = {
      window-manager.sway.enable = true;
      display-manager.tuigreet = {
        enable = true;
        autoLogin = "jfp";
      };
    };

    environment.systemPackages = with pkgs; [
      grim
      slurp
      wl-clipboard
      mako
      kanshi
      nwg-displays
    ];
  };
}
