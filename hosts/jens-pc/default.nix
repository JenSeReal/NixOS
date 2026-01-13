{
  delib,
  pkgs,
  inputs,
  ...
}:
delib.host {
  name = "jens-pc";

  rice = "synthwave84";
  type = "laptop";

  nixos = {
    imports = [inputs.nixos-hardware.nixosModules.framework-13-7040-amd];

    users.defaultUserShell = pkgs.nushell;
  };

  myconfig = {
    features.desktop-environments.hyprland.enable = true;
    features.shell-tools.enable = true;
    hardware = {
      amd-gpu = {
        enable = true;
        enableNvtop = true;
        enableRocmSupport = true;
      };
      keychron.enable = true;
      moza-r12.enable = true;
    };
    programs = {
      bitwarden.enable = true;
      codium.enable = true;
      DataLink.enable = true;
      gamemode.enable = true;
      helix.enable = true;
      sudo.enable = true;
      fish.enable = true;
      ffmpeg.enable = true;
      mpv.enable = true;
      neovide.enable = true;
      nh.enable = true;
      nix-ld.enable = true;
      nu.enable = true;
      quickemu.enable = true;
      steam.enable = true;
      vesktop.enable = true;
      virt-manager.enable = true;
      wezterm.enable = true;
      zed.enable = false;
    };
  };
}
