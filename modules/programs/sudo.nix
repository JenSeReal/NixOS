{delib, ...}:
delib.module {
  name = "programs.sudo";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    security = {
      doas.enable = false;
      sudo = {
        enable = true;
        wheelNeedsPassword = false;
      };
    };
  };
}
