{delib, ...}:
delib.module {
  name = "hardware.touchpad";

  darwin.always = {
    security.pam.services.sudo_local.touchIdAuth = true;
  };
}
