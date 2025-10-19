{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "services.nm-applet";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [networkmanagerapplet];
  };

  home.ifEnabled = {...}: {
    services.network-manager-applet.enable = true;
  };
}
