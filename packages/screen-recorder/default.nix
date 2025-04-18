{
  lib,
  stdenv,
  makeWrapper,
  wl-screenrec,
  slurp,
  pulseaudio,
  hyprland,
  jq,
}:

stdenv.mkDerivation {
  pname = "screen-recorder";
  version = "0.1.0";

  src = stdenv.mkDerivation {
    name = "screen-recorder";
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/screen-recorder <<'EOF'
      #!/usr/bin/env bash

      set -euo pipefail

      print_usage() {
        echo "Usage: screen-recorder [OPTIONS]"
        echo "Record your screen with wl-screenrec"
        echo ""
        echo "Options:"
        echo "  -a, --area       Select an area to record with slurp"
        echo "  -w, --window     Record the currently active window (Hyprland only)"
        echo "  -o, --output     Record the active output (default)"
        echo "  -d, --directory  Output directory (default: ./recordings/)"
        echo "  -h, --help       Show this help message"
      }

      # Default values
      CAPTURE_MODE="output"
      OUTPUT_DIR="./recordings"
      TIMESTAMP=$(date +%Y-%m-%d/%H%M%S)
      OUTPUT_FILE="$OUTPUT_DIR/$TIMESTAMP.mp4"
      GEOMETRY=""
      MONITOR=""
      EXTRA_ARGS=""

      # Parse arguments
      while [[ $# -gt 0 ]]; do
        case $1 in
          -a|--area)
            CAPTURE_MODE="area"
            shift
            ;;
          -w|--window)
            CAPTURE_MODE="window"
            shift
            ;;
          -o|--output)
            CAPTURE_MODE="output"
            shift
            ;;
          -d|--directory)
            OUTPUT_DIR="$2"
            TIMESTAMP=$(date +%Y-%m-%d/%H%M%S)
            OUTPUT_FILE="$OUTPUT_DIR/$TIMESTAMP.mp4"
            shift 2
            ;;
          -h|--help)
            print_usage
            exit 0
            ;;
          *)
            echo "Unknown option: $1"
            print_usage
            exit 1
            ;;
        esac
      done

      # Determine audio source
      DEFAULT_AUDIO=$(pactl get-default-source 2>/dev/null || true)
      if [ -n "$DEFAULT_AUDIO" ]; then
        AUDIO_ARGS="--audio --audio-device=$DEFAULT_AUDIO"
      else
        echo "Warning: Could not determine default audio source. Recording without audio."
        AUDIO_ARGS=""
      fi

      # Determine capture region
      if [[ "$CAPTURE_MODE" == "area" ]]; then
        echo "Select an area to record..."
        GEOMETRY=$(slurp)
        [ -z "$GEOMETRY" ] && echo "Selection cancelled" && exit 1
        GEOMETRY_ARG="-g \"$GEOMETRY\""

      elif [[ "$CAPTURE_MODE" == "window" ]]; then
        if command -v hyprctl >/dev/null; then
          echo "Using Hyprland to get active window geometry..."
          WINDOW_JSON=$(hyprctl activewindow -j)

          # Extract coordinates and dimensions from Hyprland's JSON output
          X=$(echo "$WINDOW_JSON" | jq -r '.at[0]')
          Y=$(echo "$WINDOW_JSON" | jq -r '.at[1]')
          WIDTH=$(echo "$WINDOW_JSON" | jq -r '.size[0]')
          HEIGHT=$(echo "$WINDOW_JSON" | jq -r '.size[1]')

          # Format as: "x,y WIDTHxHEIGHT" (the format slurp uses, which wl-screenrec accepts)
          GEOMETRY="$X,$Y $WIDTHx$HEIGHT"

          [ -z "$X" ] && echo "Could not get active window geometry" && exit 1
          GEOMETRY_ARG="-g \"$GEOMETRY\""
        else
          echo "Hyprland (hyprctl) is required for --window mode."
          exit 1
        fi

      elif [[ "$CAPTURE_MODE" == "output" ]]; then
        if command -v hyprctl >/dev/null; then
          echo "Using Hyprland to get active output..."
          MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
          if [ -n "$MONITOR" ]; then
            GEOMETRY_ARG="-o $MONITOR"
          else
            echo "Could not determine active monitor. Falling back to full screen."
            GEOMETRY_ARG=""
          fi
        else
          GEOMETRY_ARG=""
        fi
      fi

      # Ensure output directory exists
      mkdir -p "$(dirname "$OUTPUT_FILE")"

      # Print debugging information
      echo "Starting recording..."

      wl-screenrec --low-power=off --codec=hevc $GEOMETRY_ARG $AUDIO_ARGS -f $OUTPUT_FILE"

      echo "🎥 Recording saved to $OUTPUT_FILE"
      EOF
      chmod +x $out/bin/screen-recorder
    '';
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src/bin/screen-recorder $out/bin/
    wrapProgram $out/bin/screen-recorder \
      --prefix PATH : ${
        lib.makeBinPath [
          wl-screenrec
          slurp
          pulseaudio
          hyprland
          jq
        ]
      }
  '';

  meta = with lib; {
    description = "A wrapper around wl-screenrec with monitor selection and audio support";
    homepage = "https://github.com/your-username/screen-recorder";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ maintainers.JenSeReal ];
    mainProgram = "screen-recorder";
  };
}
