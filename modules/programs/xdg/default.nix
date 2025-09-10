{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.xdg";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };
}
