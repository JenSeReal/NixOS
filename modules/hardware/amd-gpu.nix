{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "hardware.amd-gpu";

  options = with delib;
    moduleOptions {
      enable = boolOption false;
      enableRocmSupport = boolOption false;
      enableNvtop = boolOption false;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = with pkgs;
      [
        amdgpu_top
      ]
      ++ lib.optionals cfg.enableNvtop [
        nvtopPackages.amd
      ];

    # enables RADV (Mesa) & OpenCL support
    hardware = {
      amdgpu = {
        initrd.enable = true;
        opencl.enable = true;
        overdrive.enable = true;
      };

      graphics = {
        enable = true;
        enable32Bit = true; # Critical for 32-bit games (most Steam games)
        extraPackages = with pkgs; [
          # Mesa includes RADV Vulkan driver (best performance for AMD gaming)
          mesa
          # Vulkan tools and layers
          vulkan-tools
          vulkan-loader
          vulkan-validation-layers
          vulkan-extension-layer
        ];
        extraPackages32 = with pkgs.pkgsi686Linux; [
          # 32-bit Mesa with RADV driver
          mesa
        ];
      };
    };

    nixpkgs.config.rocmSupport = cfg.enableRocmSupport;

    # Kernel parameters for better AMD GPU stability and performance
    boot.kernelParams = [
      "amdgpu.ppfeaturemask=0xffffffff" # Enable all GPU power/performance features
    ];

    # Allow userspace tools (like gamemode) to control GPU performance
    services.udev.extraRules = ''
      KERNEL=="card[0-9]", SUBSYSTEM=="drm", ACTION=="add", RUN+="${lib.getExe' pkgs.coreutils "chmod"} 666 /sys/class/drm/%k/device/power_dpm_force_performance_level"
    '';

    # Gaming-optimized environment variables
    environment.sessionVariables = {
      # Use RADV by default (generally better gaming performance than AMDVLK)
      # Games can override this if needed
      AMD_VULKAN_ICD = "RADV";
      # Enable advanced RADV features for better performance
      RADV_PERFTEST = "nggc"; # Next-gen geometry culling
      # Mesa shader cache location (helps reduce stuttering)
      MESA_SHADER_CACHE_DIR = "$XDG_CACHE_HOME/mesa_shader_cache";
    };
  };
}
