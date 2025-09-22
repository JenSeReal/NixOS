{
  lib,
  stdenv,
  makeWrapper,
  wl-screenrec,
  slurp,
  pulseaudio,
  hyprland,
  jq,
  ...
}:
stdenv.mkDerivation {
  pname = "screen-recorder";
  version = "0.1.0";

  src = stdenv.mkDerivation {
    name = "screen-recorder";
    phases = ["installPhase"];
    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/screen-recorder <<'EOF'
      #!/usr/bin/env bash

      set -euo pipefail

      print_usage() {
        echo "Usage: screen-recorder [OPTIONS]"
        echo "Record your screen with wl-screenrec."
        echo ""
        echo "Options:"
        echo "  -a, --area       Select an area to record with slurp"
        echo "  -w, --window     Record the currently active window (Hyprland only)"
        echo "  -o, --output     Record the active output (default)"
        echo "  -d, --directory  Output directory (default: ./recordings/)"
        echo "  -h, --help       Show this help message"
      }

      # Defaults
      CAPTURE_MODE="output"
      OUTPUT_DIR="./recordings"
      TIMESTAMP=$(date +%Y-%m-%d/%H%M%S)
      OUTPUT_FILE="$OUTPUT_DIR/$TIMESTAMP.mp4"
      AUDIO_ARGS=()

      check_running_recording() {
        if pgrep -x wl-screenrec >/dev/null; then
          echo "Recording already in progress. Stopping it..."
          pkill -x wl-screenrec
          echo "Recording stopped. Exiting."
          exit 0
        fi
      }

      parse_args() {
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
      }

      prepare_audio() {
        if command -v pactl >/dev/null; then
          local default_audio
          default_audio=$(pactl get-default-source 2>/dev/null || true)
          if [ -n "$default_audio" ]; then
            AUDIO_ARGS=(--audio "--audio-device=$default_audio")
          else
            echo "Warning: Could not determine default audio source. Recording without audio."
          fi
        else
          echo "Warning: pactl not found. Recording without audio."
        fi
      }

      start_recording_area() {
        echo "Select an area to record..."
        local geometry
        geometry=$(slurp)
        [ -z "$geometry" ] && echo "Selection cancelled" && exit 1

        echo "Starting recording (area)..."
        exec -a screen-recorder wl-screenrec --low-power=off --codec=hevc -g "$geometry" "''${AUDIO_ARGS[@]}" -f "$OUTPUT_FILE"
      }

      start_recording_window() {
        slurp -h >/dev/null 2>&1 || true

        if ! command -v hyprctl >/dev/null; then
          echo "Error: Hyprland (hyprctl) is required for --window mode."
          exit 1
        fi

        echo "Using Hyprland to get active window geometry..."
        local window_json x y width height geometry

        window_json=$(hyprctl activewindow -j)
        x=$(echo "$window_json" | jq -r '.at[0]')
        y=$(echo "$window_json" | jq -r '.at[1]')
        width=$(echo "$window_json" | jq -r '.size[0]')
        height=$(echo "$window_json" | jq -r '.size[1]')

        [ -z "$x" ] && echo "Could not get active window geometry" && exit 1

        geometry="$x,$y ''${width}x''${height}"

        echo "Starting recording (window)..."
        exec wl-screenrec --low-power=off --codec=hevc -g "$geometry" "''${AUDIO_ARGS[@]}" -f "$OUTPUT_FILE"
      }

      start_recording_output() {
        slurp -h >/dev/null 2>&1 || true

        local monitor=""
        if command -v hyprctl >/dev/null; then
          monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
        fi

        if [ -n "$monitor" ]; then
          echo "Starting recording (output: $monitor)..."
          exec wl-screenrec --low-power=off --codec=hevc -o "$monitor" "''${AUDIO_ARGS[@]}" -f "$OUTPUT_FILE"
        else
          echo "Error: No focused monitor detected."
          exit 1
        fi
      }

      main() {
        check_running_recording
        parse_args "$@"
        prepare_audio
        mkdir -p "$(dirname "$OUTPUT_FILE")"

        case "$CAPTURE_MODE" in
          area)
            start_recording_area
            ;;
          window)
            start_recording_window
            ;;
          output)
            start_recording_output
            ;;
          *)
            echo "Unknown capture mode: $CAPTURE_MODE"
            exit 1
            ;;
        esac
      }

      main "$@"
      EOF
      chmod +x $out/bin/screen-recorder
    '';
  };

  nativeBuildInputs = [makeWrapper];

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
    # This package only works on Linux due to Wayland dependencies
    platforms = platforms.linux;
    maintainers = with maintainers; [JenSeReal];
    mainProgram = "screen-recorder";
  };
}
