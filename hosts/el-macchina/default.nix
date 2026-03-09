{
  delib,
  pkgs,
  ...
}:
delib.host {
  name = "el-macchina";

  rice = "synthwave84";
  type = "workstation";

  nixos = {
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
