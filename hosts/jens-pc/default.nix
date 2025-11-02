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
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    environment.systemPackages = [
      pkgs.screenshotter
    ];
  };

  myconfig = {
    desktop-environments.hyprland.enable = true;
    hardware = {
      keychron.enable = true;
      moza-r12.enable = true;
    };
    programs = {
      bat.enable = true;
      btop.enable = true;
      bitwarden.enable = true;
      curl.enable = true;
      carapace.enable = true;
      codium.enable = true;
      DataLink.enable = true;
      direnv.enable = true;
      devenv.enable = true;
      git.enable = true;
      sudo.enable = true;
      fish.enable = true;
      # neovim.enable = true;
      nh.enable = true;
      nix-ld.enable = true;
      nu.enable = true;
      quickemu.enable = true;
      starship.enable = true;
      steam.enable = true;
      vesktop.enable = true;
      wezterm.enable = true;
      zed.enable = true;
    };
  };
}
