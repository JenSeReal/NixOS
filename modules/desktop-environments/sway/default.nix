{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "desktop-environments.sway";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    myconfig = {
      programs = {
        swaylock.enable = true;
        sway.enable = true;
        waybar.enable = true;
        kanshi.enable = true;
        swww.enable = true;
      };
      services.swayidle.enable = true;
    };
  };

  nixos.ifEnabled = {myconfig, ...}: {
    myconfig = {
      programs.sway.enable = true;
      # serivces.tuigreet = {
      #   enable = true;
      #   autoLogin = "jfp";
      # };
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
