{
  pkgs,
  lib,
  config,
  namespace,
  inputs,
  ...
}: let
  inherit (lib) mkForce;
  inherit (lib.${namespace}) enabled;
in {
  imports = with inputs; [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.common-hidpi
    nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  # hardware.framework.amd-7040.preventWakeOnAC = true;
  hardware.enableAllFirmware = true;

  #boot.extraModprobeConfig = '' options bluetooth disable_ertm=1 '';

  environment.sessionVariables = {
    GSK_RENDERER = "gl";
    PROTON_ENABLE_WAYLAND = "1";
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

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

  services = {
    libinput = enabled;
    fprintd = enabled;
    printing = enabled;
  };

  services.pulseaudio.enable = mkForce false;

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/"];
  };

  security.pam.services.swaylock = {
    text = ''
      auth sufficient pam_unix.so try_first_pass likeauth nullok
      auth sufficient pam_fprintd.so
      auth include login
    '';
  };

  environment.systemPackages = with pkgs; [
    bat
    btop
    capitaine-cursors
    codeium
    curl
    devenv
    davinci-resolve
    delta
    direnv
    du-dust
    eyedropper
    fd
    ffmpeg-full
    fzf
    gimp-with-plugins
    gifski
    nautilus
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
    inkscape-with-extensions
    kdePackages.kdenlive
    killall
    lapce
    libreoffice-qt
    networkmanagerapplet
    nix-direnv
    onlyoffice-bin
    pciutils
    ripgrep
    rm-improved
    spotify
    thunderbird
    # ventoy-bin-full
    vlc
    yazi
    zoxide
  ];
  services.gvfs.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [config.sops.secrets."wifi.env".path];
    profiles = {
      "FRITZ!Box 7590 EW" = {
        connection = {
          id = "FRITZ!Box 7590 EW";
          type = "wifi";
          interface-name = "wlp1s0";
        };
        wifi = {
          mode = "infrastructure";
          ssid = "FRITZ!Box 7590 EW";
        };
        wifi-security = {
          auth-alg = "open";
          key-mgmt = "wpa-psk";
          psk = "$FRITZBox_7590_EW";
        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
        proxy = {};
      };
      "FRITZ!Box 6690 BD" = {
        connection = {
          id = "FRITZ!Box 6690 BD";
          type = "wifi";
          interface-name = "wlp1s0";
        };
        wifi = {
          mode = "infrastructure";
          ssid = "FRITZ!Box 6690 BD";
        };
        wifi-security = {
          auth-alg = "open";
          key-mgmt = "wpa-psk";
          psk = "$FRITZBox_6690_BD";
        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
        proxy = {};
      };
      "PPP-Netz" = {
        connection = {
          id = "PPP-Netz";
          type = "wifi";
          interface-name = "wlp1s0";
        };
        wifi = {
          mode = "infrastructure";
          ssid = "PPP-Netz";
        };
        wifi-security = {
          auth-alg = "open";
          key-mgmt = "wpa-psk";
          psk = "$PPPNetz";
        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
        proxy = {};
      };
    };
  };

  ${namespace} = {
    theming.stylix = enabled;
    programs.gui.entertainment.gaming = {
      lutris = enabled;
      steam = enabled;
    };
    desktop.environment.hyprland = enabled;
    hardware = {
      audio.pipewire = enabled;
      bluetooth = enabled;
      opengl = enabled;
      peripherals.wheels.moza.r12 = enabled;
    };
    nix = enabled;
    security = {
      bitwarden = enabled;
      gnupg = enabled;
      keyring = enabled;
      polkit = enabled;
      sops = {
        enable = true;
        defaultSopsFile = secrets/secrets.yml;
      };
    };
    services = {
      fwupd = enabled;
    };
    system = {
      boot = {
        enable = true;
        plymouth = true;
        secureBoot = true;
      };
      cursor = enabled;
      fonts = enabled;
      keyboard = {
        enable = true;
        keychron = enabled;
      };
      locale = enabled;
      power-management = enabled;
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

  sops.secrets = {
    "wifi.env" = {
      sopsFile = ../../common/secrets/wifi.yml;
    };
    github_token = {
      sopsFile = ./secrets/secrets.yml;
    };
  };

  sops.templates."github-access-tokens.conf".content = ''
    extra-access-tokens = github.com=${config.sops.placeholder.github_token}
  '';

  nix.extraOptions = ''
    !include ${config.sops.templates."github-access-tokens.conf".path}
  '';

  system.stateVersion = "23.11";
}
