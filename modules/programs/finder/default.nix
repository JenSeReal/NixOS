{delib, ...}:
delib.module {
  name = "programs.finder";

  options = delib.singleEnableOption false;

  darwin.ifEnabled = {...}: {
    system.defaults = {
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        CreateDesktop = false;
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        QuitMenuItem = true;
        ShowStatusBar = true;
        ShowPathbar = true;
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = false;
      };
      NSGlobalDomain = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = false;
        NSTableViewDefaultSizeMode = 1;
      };
      CustomSystemPreferences = {
        finder = {
          DisableAllAnimations = true;
          ShowExternalHardDrivesOnDesktop = false;
          ShowHardDrivesOnDesktop = false;
          ShowMountedServersOnDesktop = false;
          ShowRemovableMediaOnDesktop = false;
          _FXSortFoldersFirst = true;
        };
      };
    };
  };
}
