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

      extraCompatPackages = [pkgs.proton-ge-bin];
    };
    environment.systemPackages = with pkgs; [
      # libgdiplus
      # steamcmd
      # steam-tui

      # wineWowPackages.waylandFull
      # (bottles.override {extraLibraries = pkgs: [libunwind];})
      # gamescope
      # proton-caller
      # protontricks
      # protonup-ng
      steamtinkerlaunch
      protonup-qt
    ];
  };

  darwin.ifEnabled = {...}: {
    myconfig.programs.homebrew = {
      enable = true;
      additionalCasks = ["steam"];
    };
  };
}
