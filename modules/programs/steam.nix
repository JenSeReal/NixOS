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
      extraCompatPackages = with pkgs; [
        unstable.proton-ge-bin
        unstable.steamtinkerlaunch
      ];
    };

    # Gamescope configuration
    programs.gamescope = {
      enable = true;
      package = pkgs.gamescope;
      args = [
        "--rt"              # Real-time scheduling for better performance
        "--expose-wayland"  # Enable Wayland client support
      ];
      # Note: capSysNice is disabled because it causes crashes when running within Steam
      # with error "failed to inherit capabilities: Operation not permitted"
    };

    environment.systemPackages = with pkgs; [
      wineWowPackages.waylandFull
      winetricks
      lutris
      heroic
      mangohud
      unstable.steamtinkerlaunch
    ];
  };

  darwin.ifEnabled = {...}: {
    myconfig.programs.homebrew = {
      enable = true;
      additionalCasks = ["steam"];
    };
  };
}
