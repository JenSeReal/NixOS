{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "hardware.keychron";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    hardware.keyboard.qmk.enable = true;

    environment.systemPackages = with pkgs; [via];
    services.udev.packages = with pkgs; [
      via
      qmk-udev-rules
    ];

    services.udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0914", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d03f", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    '';

    myconfig.user.extraGroups = ["input"];
  };
}
