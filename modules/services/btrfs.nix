{delib, ...}:
delib.module {
  name = "services.btrfs";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    services.btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = ["/"];
    };
  };
}
