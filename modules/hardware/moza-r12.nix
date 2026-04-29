{delib, ...}:
delib.module {
  name = "hardware.moza-r12";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    # Disable USB autosuspend for the Moza R12 to prevent disconnects
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="346e", ATTR{idProduct}=="0006", TEST=="power/control", ATTR{power/control}="on"
    '';

    myconfig = {
      programs.boxflat.enable = true;

      user.extraGroups = ["input" "dialout"];
    };
  };
}
