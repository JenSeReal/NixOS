{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.JenSeReal.virtualisation.docker;
in
{
  options.JenSeReal.virtualisation.docker = {
    enable = mkEnableOption "Wether to enable docker.";
  };

  config = mkIf cfg.enable {
    JenSeReal.programs.cli.homebrew = {
      enable = true;
      additional_casks = [
        "podman-desktop"
        "rancher"
      ];
      additional_brews = [
        "lxc"
        "rancher-cli"
      ];
    };

    environment.systemPackages = with pkgs; [
      qemu
      # libvirt
      # virt-manager

      kubectl

      colima

      docker
      docker-credential-helpers

      podman
      # podman-compose
      podman-tui
    ];

    users.groups.docker = {
      name = "docker";
      members = config.${namespace}.user.name;
    };

    launchd.agents."colima.default" = {
      command = "${pkgs.colima}/bin/colima start --foreground --cpu 8 --memory 16 --kubernetes";
      serviceConfig = {
        Label = "com.colima.default";
        RunAtLoad = true;
        KeepAlive = true;

        # StandardOutPath = "${config.${namespace}.home.configFile."colima/daemon/launchd.stdout.log".path}";
        # StandardErrorPath = "${config.${namespace}.home.configFile."colima/daemon/launchd.stderr.log".path
        # }";

        EnvironmentVariables = {
          PATH = "${pkgs.colima}/bin:${pkgs.docker}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
        };
      };
    };
  };
}
