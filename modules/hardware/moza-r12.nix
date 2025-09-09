{
  delib,
  pkgs,
  config,
  ...
}: let
  universal-pidff = config.boot.kernelPackages.callPackage (
    pkgs.unstable.path + "/pkgs/os-specific/linux/universal-pidff"
  ) {};
in
  delib.module {
    name = "hardware.moza-r12";
    options = delib.singleEnableOption false;

    nixos.ifEnabled = {
      boot = {
        extraModulePackages = [universal-pidff];
      };
      environment.systemPackages = [
        pkgs.unstable.boxflat
        pkgs.linuxConsoleTools
        # pkgs.${namespace}.ffb-tools
        # pkgs.${namespace}.monocoque
      ];
      services.udev.packages = [pkgs.unstable.boxflat];
    };
  }
