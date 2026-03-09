{
  delib,
  pkgs,
  inputs,
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

  home.always = {
    imports = [
      "${inputs.home-manager-unstable}/modules/services/colima.nix"
    ];
  };
  home.ifEnabled = {...}: {
    services.colima = {
      enable = true;
      profiles.default = {
        isActive = true;
        isService = true;
        settings = {
          cpu = 8;
          memory = 16;
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
