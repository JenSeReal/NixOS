{ channels, ... }:
(final: prev: {
  steam = channels.nixpkgs-unstable.steam.overrideAttrs (oldAttrs: {
    postInstall =
      (oldAttrs.postInstall or "")
      + ''
        # Modify the desktop file
        substituteInPlace $out/share/applications/steam.desktop \
          --replace "Exec=steam %U" "Exec=env DRI_PRIME=0 steam"
      '';
  });
})
