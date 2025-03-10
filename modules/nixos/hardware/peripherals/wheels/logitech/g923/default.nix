{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.hardware.peripherals.wheels.logitech.g923;
in
{
  options.${namespace}.hardware.peripherals.wheels.logitech.g923 = {
    enable = mkEnableOption "Whether or not to enable Logitech G923";
  };

  config = mkIf cfg.enable {

    # hardware.new-lg4ff.enable = true;

    boot = {
      # extraModulePackages = [ pkgs.${namespace}.new-lg4ff ];
      # kernelModules = [ "hid-logitech-new" ];
    };

    # Xbox controller driver
    hardware.xpadneo.enable = true;

    environment.etc = {
      "usb_modeswitch.d/046d:c261" = {
        text = ''
          # Logitech G920 Racing Wheel
          DefaultVendor=046d
          DefaultProduct=c261
          MessageEndpoint=01
          ResponseEndpoint=01
          TargetClass=0x03
          MessageContent="0f00010142"
        '';
      };
    };

    services.udev.extraRules = "ATTR{idVendor}==\"046d\", ATTR{idProduct}==\"c261\", RUN+=\"${lib.getExe pkgs.usb-modeswitch} -c '/etc/usb_modeswitch.d/046d\:c261'\"";

    services.udev.packages = with pkgs; [ oversteer ];
    environment.systemPackages = [
      pkgs.oversteer
      pkgs.usb-modeswitch
      pkgs.usb-modeswitch-data
      pkgs.linuxConsoleTools
    ];
  };
}
