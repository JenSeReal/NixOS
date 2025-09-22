{delib, ...}:
delib.module {
  name = "services.fwupd";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    services.fwupd = {
      enable = true;
      extraRemotes = ["lvfs-testing"];
    };
  };
}
