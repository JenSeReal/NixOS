{
  delib,
  pkgs,
  config,
  ...
}:
delib.module {
  name = "programs.looking-glass";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.unstable.looking-glass-client;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];

    # Create the shared memory file for Looking Glass
    systemd.tmpfiles.rules = [
      "f /dev/shm/looking-glass 0660 ${config.constants.username} kvm -"
    ];
  };

  home.ifEnabled = {cfg, ...}: {
    programs.looking-glass-client = {
      enable = true;
      package = cfg.package;
      # Additional settings can be configured here
      # See: https://looking-glass.io/docs/stable/install/#client-configuration
      settings = {
        # Example configuration - adjust as needed
        # win = {
        #   size = "1920x1080";
        #   fullScreen = true;
        # };
      };
    };
  };
}
