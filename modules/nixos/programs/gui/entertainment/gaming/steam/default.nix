{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;
  cfg = config.${namespace}.programs.gui.entertainment.gaming.steam;
in {
  options.${namespace}.programs.gui.entertainment.gaming.steam = {
    enable = mkEnableOption "Whether or not to enable pipewire.";
  };

  config = mkIf cfg.enable {
    hardware.steam-hardware = enabled;

    programs.steam = {
      enable = true;
      extest = enabled;
      localNetworkGameTransfers.openFirewall = true;
      protontricks = enabled;
      remotePlay.openFirewall = true;

      extraCompatPackages = with pkgs.unstable; [proton-ge-bin.steamcompattool];
    };
    environment.systemPackages = with pkgs; [
      libgdiplus
      steamcmd
      steamtinkerlaunch
      # steam-tui

      wineWowPackages.waylandFull
      (bottles.override {extraLibraries = pkgs: [libunwind];})
      gamescope
      lutris
      proton-caller
      protontricks
      protonup-ng
      protonup-qt
    ];
  };
}
