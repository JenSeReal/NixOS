{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.steam";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    # environment.sessionVariables = {
    #   GSK_RENDERER = "gl";
    #   PROTON_ENABLE_WAYLAND = "1";
    # };
    programs.steam = {
      enable = true;
      extest.enable = true;
      localNetworkGameTransfers.openFirewall = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [pkgs.unstable.proton-ge-bin pkgs.unstable.steamtinkerlaunch];
    };

    environment.systemPackages = with pkgs; [
      unstable.steamtinkerlaunch
      wineWowPackages.waylandFull
      winetricks
      lutris
      heroic
      mangohud
    ];
  };

  darwin.ifEnabled = {...}: {
    myconfig.programs.homebrew = {
      enable = true;
      additionalCasks = ["steam"];
    };
  };
}
