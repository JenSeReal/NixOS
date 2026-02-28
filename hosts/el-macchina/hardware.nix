{
  delib,
  inputs,
  ...
}:
delib.host rec {
  name = "el-macchina";
  system = "x86_64-linux";

  home.home.stateVersion = "25.11";
  nixos = {
    imports = [inputs.disko.nixosModules.disko];

    nixpkgs.hostPlatform = system;
    system.stateVersion = "25.11";

    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/nvme0n1";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = ["defaults"];
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "enc";
                  settings.allowDiscards = true;
                  content = {
                    type = "btrfs";
                    extraArgs = ["-f" "-L" "ROOTFS"];
                    subvolumes = {
                      "/root" = {
                        mountpoint = "/";
                        mountOptions = ["compress=zstd" "noatime"];
                      };
                      "/home" = {
                        mountpoint = "/home";
                        mountOptions = ["compress=zstd" "noatime"];
                      };
                      "/nix" = {
                        mountpoint = "/nix";
                        mountOptions = ["compress=zstd" "noatime"];
                      };
                      "/persist" = {
                        mountpoint = "/persist";
                        mountOptions = ["compress=zstd" "noatime"];
                      };
                      "/log" = {
                        mountpoint = "/var/log";
                        mountOptions = ["compress=zstd" "noatime"];
                      };
                      "/swap" = {
                        mountpoint = "/.swap";
                        swap.swapfile.size = "64G";
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  myconfig = {
    boot = {
      enable = true;
      plymouth = true;
      secureBoot = true;
    };
    hardware = {
      graphics.enable = true;
    };
    services = {
      btrfs.enable = true;
      fwupd.enable = true;
    };
  };
}
