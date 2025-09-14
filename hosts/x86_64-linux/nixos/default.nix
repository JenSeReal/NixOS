{
  delib,
  inputs,
  pkgs,
  lib,
  ...
}:
delib.host {
  name = "nixos";
  rice = "synthwave84";
  type = "laptop";

  nixos = {
    imports = with inputs; [
      ./hardware-configuration.nix
      nixos-hardware.nixosModules.common-hidpi
      nixos-hardware.nixosModules.framework-13-7040-amd
    ];

    hardware.framework.amd-7040.preventWakeOnAC = true;
    # hardware.enableAllFirmware = true;

    #boot.extraModprobeConfig = '' options bluetooth disable_ertm=1 '';

    # environment.sessionVariables = {
    #   GSK_RENDERER = "gl";
    #   PROTON_ENABLE_WAYLAND = "1";
    # };

    # networking.hostName = "nixos";
    networking.networkmanager.enable = true;

    # users.defaultUserShell = pkgs.nushell;

    # users.users."jfp" = {
    #   isNormalUser = true;
    #   extraGroups = [
    #     "networkmanager"
    #     "wheel"
    #   ];
    #   packages = with pkgs; [
    #     freshfetch
    #   ];
    # };

    # services = {
    #   libinput.enable = true;
    #   fprintd.enable = true;
    #   printing.enable = true;
    # };

    # services.pulseaudio.enable = lib.mkForce false;

    services.btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = ["/"];
    };

    environment.systemPackages = with pkgs; [
      # bat
      # btop
      # capitaine-cursors
      # curl
      # davinci-resolve
      # delta
      # direnv
      # du-dust
      # eyedropper
      # fd
      # ffmpeg-full
      # fzf
      # gimp-with-plugins
      # gifski
      # nautilus
      # hunspell
      # hunspellDicts.de_DE
      # hunspellDicts.en_US
      # inkscape-with-extensions
      # kdePackages.kdenlive
      # killall
      # lapce
      # libreoffice-qt
      # networkmanagerapplet
      # nix-direnv
      # onlyoffice-bin
      # pciutils
      # ripgrep
      # rm-improved
      # spotify
      # thunderbird
      # # ventoy-bin-full
      # vlc
      # yazi
      # zoxide
    ];
    # services.gvfs.enable = true;

    # programs.nix-ld.enable = true;
    # programs.nix-ld.libraries = [];

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    # networking.networkmanager.ensureProfiles = {
    #   environmentFiles = [config.sops.secrets."wifi.env".path];
    #   profiles = {
    #     "FRITZ!Box 7590 EW" = {
    #       connection = {
    #         id = "FRITZ!Box 7590 EW";
    #         type = "wifi";
    #         interface-name = "wlp1s0";
    #       };
    #       wifi = {
    #         mode = "infrastructure";
    #         ssid = "FRITZ!Box 7590 EW";
    #       };
    #       wifi-security = {
    #         auth-alg = "open";
    #         key-mgmt = "wpa-psk";
    #         psk = "$FRITZBox_7590_EW";
    #       };
    #       ipv4 = {
    #         method = "auto";
    #       };
    #       ipv6 = {
    #         addr-gen-mode = "default";
    #         method = "auto";
    #       };
    #       proxy = {};
    #     };
    #     "FRITZ!Box 6690 BD" = {
    #       connection = {
    #         id = "FRITZ!Box 6690 BD";
    #         type = "wifi";
    #         interface-name = "wlp1s0";
    #       };
    #       wifi = {
    #         mode = "infrastructure";
    #         ssid = "FRITZ!Box 6690 BD";
    #       };
    #       wifi-security = {
    #         auth-alg = "open";
    #         key-mgmt = "wpa-psk";
    #         psk = "$FRITZBox_6690_BD";
    #       };
    #       ipv4 = {
    #         method = "auto";
    #       };
    #       ipv6 = {
    #         addr-gen-mode = "default";
    #         method = "auto";
    #       };
    #       proxy = {};
    #     };
    #     "PPP-Netz" = {
    #       connection = {
    #         id = "PPP-Netz";
    #         type = "wifi";
    #         interface-name = "wlp1s0";
    #       };
    #       wifi = {
    #         mode = "infrastructure";
    #         ssid = "PPP-Netz";
    #       };
    #       wifi-security = {
    #         auth-alg = "open";
    #         key-mgmt = "wpa-psk";
    #         psk = "$PPPNetz";
    #       };
    #       ipv4 = {
    #         method = "auto";
    #       };
    #       ipv6 = {
    #         addr-gen-mode = "default";
    #         method = "auto";
    #       };
    #       proxy = {};
    #     };
    #   };
    # };

    # myconfig = {
    #   programs = {
    #     # lutris.enable = true;
    #     steam.enable = true;
    #     bitwarden.enable = true;
    #     gnupg.enable = true;
    #     polkit.enable = true;
    #     sops = {
    #       enable = true;
    #       defaultSopsFile = secrets/secrets.yml;
    #     };
    #     git.enable = true;
    #     nu.enable = true;
    #     fish.enable = true;
    #     starship.enable = true;
    #     carapace.enable = true;
    #   };
    #   desktop-environments.hyprland.enable = true;
    #   hardware = {
    #     bluetooth.enable = true;
    #     opengl.enable = true;
    #     moza-r12.enable = true;
    #     keyboard.enable = true;
    #     keychron.enable = true;
    #   };
    #   services = {
    #     fwupd.enable = true;
    #     gnome-keyring.enable = true;
    #     pipewire.enable = true;
    #   };
    #   settings = {
    #     boot = {
    #       enable = true;
    #       plymouth = true;
    #       secureBoot = true;
    #     };
    #     cursor.enable = true;
    #     fonts.enable = true;
    #     localization.enable = true;
    #     power-management.enable = true;
    #   };
    # };

    # sops.secrets = {
    #   "wifi.env" = {
    #     sopsFile = ../../common/secrets/wifi.yml;
    #   };
    #   github_token = {
    #     sopsFile = ./secrets/secrets.yml;
    #   };
    # };

    # sops.templates."github-access-tokens.conf".content = ''
    #   extra-access-tokens = github.com=${config.sops.placeholder.github_token}
    # '';

    # nix.extraOptions = ''
    #   !include ${config.sops.templates."github-access-tokens.conf".path}
    # '';

    system.stateVersion = "23.11";
  };

  home = {myconfig, ...}: {
    # sops.secrets."ssh/jfp.one" = {
    #   sopsFile = ./secrets/ssh.yml;
    #   path = "${config.home.homeDirectory}/.ssh/hosts/jfp.one";
    # };

    nix.extraOptions = "";
  };

  myconfig = {
    settings = {
      boot = {
        enable = true;
        plymouth = true;
        secureBoot = true;
      };
    };
    # programs = {
    #   hyprland.enable = true;
    #   git.enable = true;
    #   ssh = {
    #     enable = true;
    #     # includes = ["${myconfig.home.homeDirectory}/.ssh/hosts/jfp.one"];
    #   };
    #   direnv.enable = true;

    #   fish.enable = true;
    #   nu.enable = true;
    #   starship.enable = true;

    #   # kitty.enable = true;
    #   wezterm.enable = true;
    #   codium.enable = true;
    #   zed.enable = true;
    #   sops.enable = true;
    # };
  };
}
