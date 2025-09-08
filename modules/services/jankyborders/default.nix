{
  delib,
  lib,
  ...
}:
delib.module {
  name = "services.jankyborders";

  options = delib.singleEnableOption false;

  darwin.ifEnabled = {...}: {
    services.jankyborders = {
      enable = true;
      style = "round";
      width = 1.0;
      hidpi = true;
      blacklist = ["Kandji" "FaceTime" "Screen Sharing"];
      active_color = lib.mkDefault "0xffffffff"; # so that stylix can override
      inactive_color = lib.mkDefault "0x00000000"; # so that stylix can override
    };
  };
}
