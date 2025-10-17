{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  dbus,
  pkgsCross,
}: let
  pname = "datalink";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "LukasLichten";
    repo = "Datalink";
    rev = "0a7ff08f9fe14809dbf11ab405194248f2e051c5";
    hash = "sha256-NnhD69PncWwv3bLurqJUPEEyQfWIxALkxl1icEukSVM=";
  };

  cargoHash = "sha256-OQL9ePfNWbR8wmAip0qjr1xhpejzcK1Y9sbCA3GjaaM=";

  # Cross-compile the Windows bridge component
  windowsBridge = pkgsCross.mingwW64.rustPlatform.buildRustPackage {
    pname = "${pname}-shm-bridge";
    inherit version src;

    cargoHash = cargoHash;

    buildAndTestSubdir = "datalink-shm-bridge";

    buildType = "release";

    CARGO_BUILD_TARGET = "x86_64-pc-windows-gnu";

    doCheck = false;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp target/x86_64-pc-windows-gnu/release/datalink-shm-bridge.exe $out/bin/
      runHook postInstall
    '';

    meta = {
      description = "Windows bridge component for Datalink";
      platforms = lib.platforms.windows;
    };
  };
in
  rustPlatform.buildRustPackage {
    inherit pname version src cargoHash;

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      dbus
    ];

    # The bridge exe needs to be available during build as it gets embedded via include_bytes!
    preBuild = ''
      mkdir -p target/x86_64-unknown-linux-gnu/x86_64-pc-windows-gnu/release
      cp ${windowsBridge}/bin/datalink-shm-bridge.exe target/x86_64-unknown-linux-gnu/x86_64-pc-windows-gnu/release/
    '';

    buildType = "release";
    checkType = "release";

    meta = with lib; {
      description = "Bridge between Steam/Proton games and Linux native tools via shared memory";
      longDescription = ''
        Datalink is a wrapper for Steam/Proton games that creates shared memory bridges,
        allowing Linux native applications to read telemetry and game data from Windows
        games running under Wine/Proton.

        Usage: Add "Datalink %command%" to your Steam game's launch options.

        Note: The Windows bridge component (datalink-shm-bridge.exe) is pre-compiled
        and embedded in the binary. This package is built without the debug console feature.
      '';
      homepage = "https://github.com/LukasLichten/Datalink";
      license = licenses.mit;
      maintainers = with maintainers; [JenSeReal];
      platforms = platforms.linux;
      mainProgram = "Datalink";
    };
  }
