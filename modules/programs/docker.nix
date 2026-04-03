{
  delib,
  pkgs,
  inputs,
  lib,
  ...
}:
delib.module {
  name = "programs.docker";
  options = delib.singleEnableOption false;

  darwin.ifEnabled = {myconfig, ...}: {
    environment.systemPackages = with pkgs; [
      qemu
      libvirt
      virt-manager

      docker
      docker-credential-helpers
    ];

    users.groups.docker = {
      name = "docker";
      members = myconfig.constants.username;
    };
  };

  home.always = lib.mkIf pkgs.stdenv.isDarwin {
    imports = [
      "${inputs.home-manager-unstable}/modules/services/colima.nix"
    ];
  };

  home.ifEnabled = lib.mkIf pkgs.stdenv.isDarwin {
    services.colima = {
      enable = true;
      package = pkgs.unstable.colima;
      profiles.default = {
        isActive = true;
        isService = false;
        settings = {
          cpu = 4;
          memory = 8;
          kubernetes.enabled = true;
        };
      };
    };
  };

  nixos.ifEnabled = {myconfig, ...}: {
    virtualisation.docker.enable = true;
    users.extraGroups.docker.members = [myconfig.username];
  };
}
