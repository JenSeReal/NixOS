{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "desktop-environments.sway";
  options = delib.singleEnableOption false;

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
