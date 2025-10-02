{
  lib,
  delib,
  pkgs,
  ...
}:
delib.overlayModule {
  name = "firefox-addons";
  overlay = final: prev: {
    oversteer = pkgs.unstable.oversteer.overrideAttrs (oldAttrs: {
      postInstall =
        (oldAttrs.postInstall or "")
        + ''
          substituteInPlace $out/lib/udev/rules.d/99-fanatec-wheel-perms.rules \
            --replace "/usr/bin/evdev-joystick" "${lib.getExe' final.pkgs.linuxConsoleTools "evdev-joystick"}"
        '';
    });
  };
}
