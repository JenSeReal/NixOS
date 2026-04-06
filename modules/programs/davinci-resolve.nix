{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.davinci-resolve";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.davinci-resolve;
      amdgpu = {
        enable = boolOption true;
        opencl = boolOption true;
      };
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages =
      [cfg.package]
      ++ (
        if cfg.amdgpu.enable
        then with pkgs; [
          rocmPackages.clr
          rocmPackages.rocminfo
          rocmPackages.rocm-runtime
        ]
        else []
      );

    hardware.graphics.extraPackages =
      if cfg.amdgpu.opencl
      then with pkgs; [
        rocmPackages.clr
        rocmPackages.clr.icd
      ]
      else [];
  };
}
