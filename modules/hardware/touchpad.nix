{delib, ...}:
delib.module {
  name = "hardware.touchpad";

  darwin.always = {
    myconfig.programs.homebrew = {
      enable = true;
      additionalCasks = [
        {
          name = "middleclick";
          args = {
            no_quarantine = true;
          };
        }
      ];
    };

    launchd.user.agents.middleclick = {
      command = "/Applications/MiddleClick.app/Contents/MacOS/MiddleClick";
      serviceConfig = {
        RunAtLoad = true;
      };
    };

    system.defaults = {
      trackpad = {
        ActuationStrength = 0;
        Clicking = true;
        Dragging = true;
        FirstClickThreshold = 1;
        SecondClickThreshold = 1;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
        TrackpadThreeFingerTapGesture = 2;
      };
      NSGlobalDomain = {
        ApplePressAndHoldEnabled = true;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.trackpad.trackpadCornerClickBehavior" = 1;
        "com.apple.trackpad.scaling" = 1.0;
        "com.apple.swipescrolldirection" = true;
      };
    };
  };
}
