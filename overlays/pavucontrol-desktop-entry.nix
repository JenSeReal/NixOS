{delib, ...}:
delib.overlayModule {
  name = "pavucontrol-desktop-entry";
  overlay = final: prev: {
    pavucontrol = prev.pavucontrol.overrideAttrs (old: {
      desktopItems = [
        (final.makeDesktopItem {
          name = "pavucontrol";
          desktopName = "PulseAudio Volume Control";
          genericName = "Volume Control";
          comment = "Adjust the volume level and device configuration for PulseAudio";
          exec = "pavucontrol";
          icon = "multimedia-volume-control";
          categories = ["AudioVideo" "Mixer" "GTK"];
          startupNotify = true;
        })
      ];

      nativeBuildInputs =
        (old.nativeBuildInputs or [])
        ++ [
          final.copyDesktopItems
        ];
    });
  };
}
