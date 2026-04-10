{
  delib,
  pkgs,
  ...
}: let
  davinci-wrapped = pkgs.symlinkJoin {
    name = "davinci-resolve";
    paths = [pkgs.unstable.davinci-resolve];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/davinci-resolve \
        --set DRI_PRIME pci-0000_03_00_0 \
        --set MESA_VK_DEVICE_SELECT 1002:7550 \
        --set QT_QPA_PLATFORM xcb \
        --set OCL_ICD_VENDORS /run/opengl-driver/etc/OpenCL/vendors
    '';
  };
in
  delib.module {
    name = "programs.davinci-resolve";
    options = with delib;
      moduleOptions {
        enable = boolOption false;
      };
    nixos.ifEnabled = {cfg, ...}: {
      environment.systemPackages = [davinci-wrapped];
    };
  }
