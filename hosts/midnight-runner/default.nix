{
  delib,
  pkgs,
  inputs,
  modulesPath,
  lib,
  ...
}:
delib.deploy {
  name = "midnight-runner";
  hostname = "152.53.135.216";
  sshPort = 50022;
  system = "x86_64-linux";

  rice = "synthwave84";
  type = "server";

  home.home.stateVersion = "25.05";
  nixos = {
    imports = [
      inputs.disko.nixosModules.disko
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "25.05";

    boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = [];
    boot.extraModulePackages = [];

    networking.useDHCP = lib.mkDefault true;

    disko.devices.disk.midnight-runner-main = {
      type = "disk";
      device = "/dev/vda";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1M";
            type = "EF02";
          };
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };

    users.defaultUserShell = pkgs.nushell;

    networking.hostName = "midnight-runner";

    users.users.jfp = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager"];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJnn80mYyCNvHpb+WooP00/YqLf+Jpe1a+Bu5ck0Aaz6 jens@plueddemann.de"
      ];
    };

    # Server-specific configuration
    services.openssh = {
      enable = true;
      ports = [50022];
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [50022];
    };
  };

  myconfig = {
    features = {
      shell-tools.enable = true;
      k8s-tools.enable = true;
    };
    programs = {
      helix.enable = true;
      sudo.enable = true;
      fish.enable = true;
      nh.enable = true;
      nu.enable = true;
    };
    services.k3s = {
      enable = true;
      cilium.replaceKubeProxy = true;
      helmfile = {
        enable = true;
        # Uses default helmfile from modules/services/k3s/helmfile.yaml
        # You can override by setting manifestPath to a custom location
        completedIf = "kubectl get pod -n flux-system -l app.kubernetes.io/name=source-controller";
      };
    };
  };
}
