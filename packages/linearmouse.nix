{delib, ...}:
delib.package {
  name = "linearmouse";

  package = {
    lib,
    stdenv,
    fetchurl,
    ...
  }:
    stdenv.mkDerivation rec {
      pname = "linearmouse";
      version = "0.11.1";

      src = fetchurl {
        url = "https://github.com/linearmouse/linearmouse/releases/download/v${version}/LinearMouse.dmg";
        sha256 = "sha256-yI2jeB0gsuxA5WPaVzm9bES5GaGGXsWmZzDfKakEAsU=";
      };

      nativeBuildInputs = [];

      __noChroot = true;

      unpackPhase = ''
        mnt=$(mktemp -d)
        /usr/bin/hdiutil attach -readonly -nobrowse -mountpoint "$mnt" "$src"
        cp -r "$mnt/LinearMouse.app" .
        /usr/bin/hdiutil detach "$mnt"
        rmdir "$mnt"
      '';

      installPhase = ''
        mkdir -p "$out/Applications"
        cp -r LinearMouse.app "$out/Applications/"
      '';

      meta = {
        description = "The mouse and trackpad tool for macOS";
        homepage = "https://linearmouse.app";
        license = lib.licenses.mit;
        maintainers = with lib.maintainers; [JenSeReal];
        platforms = lib.platforms.darwin;
        sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      };
    };
}
