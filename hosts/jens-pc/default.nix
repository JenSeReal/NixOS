{
  delib,
  pkgs,
  ...
}:
delib.host {
  name = "jens-pc";

  rice = "synthwave84";
  type = "laptop";

  nixos = {
    users.defaultUserShell = pkgs.nushell;
  };

  myconfig = {
    features.desktop-environments.hyprland.enable = true;
    features.shell-tools.enable = true;
    hardware = {
      keychron.enable = true;
      moza-r12.enable = true;
    };
    programs = {
      bitwarden.enable = true;
      codium.enable = true;
      DataLink.enable = true;
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
      zed.enable = true;
    };
  };
}
