{
  delib,
  pkgs,
  inputs,
  ...
}:
delib.host {
  name = "el-macchina";

  rice = "synthwave84";
  type = "workstation";

  nixos = {
    imports = [
      # AMD Ryzen 9850X3D (Zen 5) CPU support
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate

      # AMD Radeon 9070XT (RDNA 4) GPU support
      inputs.nixos-hardware.nixosModules.common-gpu-amd

      # NVMe SSD optimizations
      inputs.nixos-hardware.nixosModules.common-pc-ssd
    ];

    users.defaultUserShell = pkgs.nushell;
  };

  myconfig = {
    features.desktop-environments.hyprland.enable = true;
    features.shell-tools.enable = true;

    hardware = {
      bluetooth.enable = true;
      graphics.enable = true;
      keychron.enable = true;
      moza-r12.enable = true;
      openrgb.enable = true;
    };

    programs = {
      boxflat.enable = true;
      codium.enable = true;
      DataLink.enable = true;
      gamemode.enable = true;
      fish.enable = true;
      nh.enable = true;
      nix-ld.enable = true;
      nu.enable = true;
      sudo.enable = true;
      quickemu.enable = true;
      steam.enable = true;
      vesktop.enable = true;
      virt-manager.enable = true;
      wezterm.enable = true;
      zed.enable = true;
    };
  };
}
