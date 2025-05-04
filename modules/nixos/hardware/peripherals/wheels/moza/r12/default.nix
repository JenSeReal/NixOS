{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  universal-pidff = config.boot.kernelPackages.callPackage (
    pkgs.unstable.path + "/pkgs/os-specific/linux/universal-pidff"
  ) { };

  cfg = config.${namespace}.hardware.peripherals.wheels.moza.r12;
in
{
  options.${namespace}.hardware.peripherals.wheels.moza.r12 = {
    enable = mkEnableOption "Whether or not to enable Moza R12.";
  };
  config = mkIf cfg.enable {
    boot = {
      extraModulePackages = [ universal-pidff ];
    };
    environment.systemPackages = [
      pkgs.unstable.boxflat
      pkgs.linuxConsoleTools
      # pkgs.${namespace}.ffb-tools
    ];
    services.udev.packages = [ pkgs.unstable.boxflat ];
  };
}
