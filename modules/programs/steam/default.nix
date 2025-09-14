{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.steam";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    hardware.steam-hardware.enable = true;

    programs.steam = {
      enable = true;
      extest.enable = true;
      localNetworkGameTransfers.openFirewall = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;

      extraCompatPackages = with pkgs.unstable; [proton-ge-bin.steamcompattool];
    };
    environment.systemPackages = with pkgs; [
      # libgdiplus
      # steamcmd
      # steamtinkerlaunch
      # steam-tui

      # wineWowPackages.waylandFull
      # (bottles.override {extraLibraries = pkgs: [libunwind];})
      # gamescope
      # proton-caller
      # protontricks
      # protonup-ng
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
