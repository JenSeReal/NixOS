{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.podman";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.unstable.podman;
    };

  home.ifEnabled = {cfg, ...}: {
    services.podman = {
      enable = true;
      package = cfg.package;
    };

    home.packages = with pkgs.unstable; [
      buildah
      skopeo
      podman-compose
      podman-tui
      dive
    ];
  };

  nixos.ifEnabled = {
    cfg,
    myconfig,
    ...
  }: {
    virtualisation = {
      podman = {
        enable = true;
        package = cfg.package;
        dockerCompat = true;
        dockerSocket.enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      containers.enable = true;
    };

    users.extraGroups.podman.members = [myconfig.user.name];
  };
}
