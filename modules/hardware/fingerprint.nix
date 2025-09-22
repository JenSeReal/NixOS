{delib, ...}:
delib.module {
  name = "hardware.fingerprint";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    services.fprintd.enable = true;
  };

  darwin.always = {
    security.pam.services.sudo_local.touchIdAuth = true;
  };
}
