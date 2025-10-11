{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.steam";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    programs.steam = {
      enable = true;
      extest.enable = true;
      localNetworkGameTransfers.openFirewall = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
    };

    programs.gamemode.enable = true;
    environment.systemPackages = with pkgs; [
      steamtinkerlaunch
      protonup-qt
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
