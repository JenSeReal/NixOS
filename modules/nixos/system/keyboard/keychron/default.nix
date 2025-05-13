{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.system.keyboard.keychron;
in
{

  options.${namespace}.system.keyboard.keychron = {
    enable = mkEnableOption "Options for the keyboard.";
  };

  config = mkIf cfg.enable {
    hardware.keyboard.qmk.enable = true;

    environment.systemPackages = with pkgs; [ via ];
    services.udev.packages = with pkgs; [
      via
      qmk-udev-rules
    ];

    services.udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0914", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d03f", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    '';

    users.users.jfp = {
      extraGroups = [ "input" ];
    };
  };
}
