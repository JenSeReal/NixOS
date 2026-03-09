{delib, ...}:
delib.module {
  name = "hardware.mouse";

  darwin.always = {...}: {
    myconfig.programs.homebrew = {
      enable = true;
      additionalCasks = [
        "unnaturalscrollwheels"
      ];
    };

    system.defaults.".GlobalPreferences"."com.apple.mouse.scaling" = 2.0;

    launchd.user.agents.unnaturalscrollwheels = {
      command = "/Applications/UnnaturalScrollWheels.app/Contents/MacOS/UnnaturalScrollWheels";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
      };
    };
  };
}
