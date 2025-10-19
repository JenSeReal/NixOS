{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.docker";
  options = delib.singleEnableOption false;

  darwin.ifEnabled = {myconfig, ...}: {
    myconfig.programs.homebrew = {
      enable = true;
      additionalCasks = [
        "podman-desktop"
        "rancher"
      ];
      additionalBrews = [
        "lxc"
        "rancher-cli"
      ];
    };

    environment.systemPackages = with pkgs; [
      qemu
      libvirt
      virt-manager

      kubectl

      colima

      docker
      docker-credential-helpers

      podman
      podman-compose
      podman-tui
    ];

    users.groups.docker = {
      name = "docker";
      members = myconfig.constants.username;
    };

    launchd.agents."colima.default" = {
      command = "${pkgs.colima}/bin/colima start --foreground --cpu 8 --memory 16 --kubernetes";
      serviceConfig = {
        Label = "com.colima.default";
        RunAtLoad = true;
        KeepAlive = true;

        EnvironmentVariables = {
          PATH = "${pkgs.colima}/bin:${pkgs.docker}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
        };
      };
    };
  };

  nixos.ifEnabled = {myconfig, ...}: {
    virtualisation.docker.enable = true;
    users.extraGroups.docker.members = [myconfig.username];
  };
}
