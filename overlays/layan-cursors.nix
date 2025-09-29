{delib, ...}:
delib.overlayModule {
  name = "layan-cursors";
  overlay = final: prev: {
    layan-cursors = prev.layan-cursors.overrideAttrs (oldAttrs: {
      installPhase = ''
        runHook preInstall
        install -dm 0755 $out/share/icons
        cp -R dist $out/share/icons/layan-cursors
        cp -R dist-border $out/share/icons/layan-border-cursors
        cp -R dist-white $out/share/icons/layan-white-cursors
        runHook postInstall
      '';
    });
  };
}
