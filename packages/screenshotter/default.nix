{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenv.mkDerivation rec {
  pname = "screenshotter";
  version = "0.1.0";

  dontUnpack = true;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  buildInputs = with pkgs; [
    bash
    grimblast
    grim
    slurp
    wl-clipboard
    jq
    libnotify
    hyprpicker
    hyprland
  ];

  installPhase = ''
    mkdir -p $out/bin

    cat > $out/bin/screenshotter << 'EOF'
    #!/usr/bin/env bash

    set -euo pipefail

    ACTION=$1
    TARGET=$2
    BASEFOLDER=''${3:-$HOME/Pictures}

    if [[ "$ACTION" != "save" && "$ACTION" != "copy" && "$ACTION" != "copysave" && "$ACTION" != "edit" ]]; then
      echo "Usage:"
      echo "  screenshotter (copy|save|copysave|edit) [active|screen|output|area] [FOLDER]"
      exit 1
    fi

    if [[ "$ACTION" = "save" || "$ACTION" = "copysave" || "$ACTION" = "edit" ]]; then
      DATE=$(date +%F)
      TIMESTAMP=$(date -Ins | tr ':' '-')
      DEST="$BASEFOLDER/$DATE"
      mkdir -p "$DEST"
      FILE="$DEST/$TIMESTAMP.png"
      grimblast --notify --freeze "$ACTION" "$TARGET" "$FILE"
    else
      grimblast --notify --freeze "$ACTION" "$TARGET"
    fi
    EOF

    chmod +x $out/bin/screenshotter

    wrapProgram $out/bin/screenshotter \
      --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
  '';

  meta = with pkgs.lib; {
    description = "Grimblast wrapper with auto-organized timestamped screenshots";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = [ maintainers.JenSeReal ];
    mainProgram = "screenshotter";
  };
}
