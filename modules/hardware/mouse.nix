{delib, pkgs, ...}:
delib.module {
  name = "hardware.mouse";

  darwin.always = {...}: {
    system.defaults.".GlobalPreferences"."com.apple.mouse.scaling" = 2.0;

    environment.systemPackages = [pkgs.linearmouse];

    launchd.user.agents.linearmouse = {
      command = "${pkgs.linearmouse}/Applications/LinearMouse.app/Contents/MacOS/LinearMouse";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
      };
    };
  };
}
