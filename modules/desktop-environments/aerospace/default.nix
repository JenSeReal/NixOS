{delib, ...}:
delib.module {
  name = "desktop-environments.aerospace";
  options = delib.singleEnableOption false;

  darwin.ifEnabled = {
    myconfig = {
      programs = {
        activity-monitor.enable = true;
        aerospace.enable = true;
        dock.enable = true;
        finder.enable = true;
        raycast.enable = true;
        sketchybar.enable = true;
      };

      services = {
        jankyborders.enable = true;
      };
    };

    system.defaults = {
      screencapture = {
        disable-shadow = true;
        location = "$HOME/Pictures/screenshots/";
        type = "png";
      };
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleShowScrollBars = "WhenScrolling";
        AppleScrollerPagingBehavior = true;
        AppleSpacesSwitchOnActivate = false;

        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticInlinePredictionEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSDisableAutomaticTermination = true;
        NSDocumentSaveNewDocumentsToCloud = false;

        _HIHideMenuBar = false;
      };
      CustomSystemPreferences = {
        NSGlobalDomain = {
          AppleSpacesSwitchOnActivate = false;
          WebKitDeveloperExtras = true;
        };
      };
      CustomUserPreferences = {
        NSGlobalDomain = {
          AppleSpacesSwitchOnActivate = false;
          WebKitDeveloperExtras = true;
        };
        "com.apple.finder" = {
          ShowExternalHardDrivesOnDesktop = false;
          ShowHardDrivesOnDesktop = false;
          ShowMountedServersOnDesktop = false;
          ShowRemovableMediaOnDesktop = false;
          _FXSortFoldersFirst = true;
        };
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.screensaver" = {
          askForPassword = 1;
          askForPasswordDelay = 0;
        };
        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false;
        };
        "com.apple.print.PrintingPrefs" = {
          "Quit When Finished" = true;
        };
        "com.apple.SoftwareUpdate" = {
          AutomaticCheckEnabled = true;
          ScheduleFrequency = 1;
          AutomaticDownload = 1;
          CriticalUpdateInstall = 1;
        };
        "com.apple.ImageCapture".disableHotPlug = true;
        "com.apple.commerce".AutoUpdate = true;
      };
    };
  };
}
