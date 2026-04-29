{delib, ...}:
delib.package {
  name = "kfrgb";

  package = {
    lib,
    stdenv,
    fetchFromGitHub,
    makeWrapper,
    i2c-tools,
    lshw,
    perl,
    yad,
    ...
  }:
    stdenv.mkDerivation rec {
      pname = "kfrgb";
      version = "e8bec63";

      src = fetchFromGitHub {
        owner = "KeyofBlueS";
        repo = "kfrgb";
        rev = "e8bec63d373adb41b6c7034cc702dee924792508";
        sha256 = "sha256-OJlpHHN1trT5YjouNHqEqa3ml4fXiSD8C28rUSqug6M=";
      };

      nativeBuildInputs = [makeWrapper];

      buildInputs = [
        i2c-tools
        lshw
        perl
        yad
      ];

      dontBuild = true;

      installPhase = ''
        install -Dm755 kfrgb.sh $out/bin/kfrgb
        wrapProgram $out/bin/kfrgb \
          --prefix PATH : ${lib.makeBinPath [i2c-tools lshw perl yad]}
      '';

      meta = with lib; {
        description = "Control RGB LEDs of Kingston Fury Beast/Renegade DDR5 RAM via I2C";
        homepage = "https://github.com/KeyofBlueS/kfrgb";
        license = licenses.gpl3Only;
        maintainers = [];
        mainProgram = "kfrgb";
        platforms = platforms.linux;
      };
    };
}
