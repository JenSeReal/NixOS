{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.xdg";
  options = delib.singleEnablxeOption false;

  nixos.ifEnabled = {
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };
}
