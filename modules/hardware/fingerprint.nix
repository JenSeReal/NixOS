{delib, ...}:
delib.module {
  name = "hardware.touchpad";

  options = with delib;
    moduleOptions {
      enable = boolOption true;
    };

  darwin.always = {
    security.pam.services.sudo_local.touchIdAuth = true;
  };
}
