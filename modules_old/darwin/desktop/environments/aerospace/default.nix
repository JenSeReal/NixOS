{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.desktop.environments.aerospace;
in
{
  options.${namespace}.desktop.environments.aerospace = {
    enable = mkEnableOption "Enable aerospace desktop environment";
  };

  config = mkIf cfg.enable {
    JenSeReal.desktop = {
      bars.sketchybar = enabled;
      bars.dock = enabled;
      launchers.raycast = enabled;
      window-managers.aerospace = enabled;
    };
    JenSeReal.programs.gui = {
      activity-monitor = enabled;
      finder = enabled;
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
