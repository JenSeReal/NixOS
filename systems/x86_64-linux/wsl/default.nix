{
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) enabled;

in
{
  imports = [
    ./hardware-configuration.nix
  ];

  users.defaultUserShell = pkgs.nushell;
  users.users."jfp" = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      firefox
      freshfetch
    ];
  };

  environment.systemPackages = with pkgs; [
    bat
    btop
    codeium
    curl
    delta
    direnv
    du-dust
    fd
    fzf
    killall
    nix-direnv
    pciutils
    ripgrep
    rm-improved
    yazi
    zoxide
  ];

  programs.nix-ld.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  ${namespace} = {
    nix = enabled;
    security = {
      gnupg = enabled;
      keyring = enabled;
      polkit = enabled;
      sops = {
        enable = true;
        defaultSopsFile = secrets/secrets.yml;
      };
    };
    system = {
      keyboard = enabled;
      locale = enabled;
      shells.nushell = enabled;
      shells.fish = enabled;
      shells.addons.starship = enabled;
      time = enabled;
    };
    programs = {
      cli = {
        git = enabled;
      };
    };
  };

  system.stateVersion = "24.11";
}
