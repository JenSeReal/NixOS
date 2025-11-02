{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "programs.vesktop";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [
      vesktop
    ];
  };

  home.ifEnabled = {myconfig, ...}: {
    xdg.desktopEntries.discord = lib.mkIf (!myconfig.programs.discord.enable) {
      name = "Discord";
      exec = "vesktop %U";
      icon = "vesktop";
      genericName = "Internet Messenger";
      categories = ["Network" "InstantMessaging" "Chat"];
    };
  };
}
