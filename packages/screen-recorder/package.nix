{
  lib,
  stdenv,
  makeWrapper,
  wl-screenrec,
  slurp,
  pipewire,
  pulseaudio,
  hyprland,
  jq,
  libnotify,
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
        echo "  -m, --mic        Include microphone audio along with desktop audio"
        echo "  -h, --help       Show this help message"
      }

      # Defaults
      CAPTURE_MODE="output"
      OUTPUT_DIR="./recordings"
      TIMESTAMP=$(date +%Y-%m-%d/%H%M%S)
      OUTPUT_FILE="$OUTPUT_DIR/$TIMESTAMP.mp4"
      INCLUDE_MIC=false
      VIRTUAL_SINK_NAME="screen-recorder-combined"

      # Video encoding settings
      VIDEO_CODEC="av1"
      VIDEO_BITRATE="2 MB"
      LOW_POWER="off"

      # Audio encoding settings
      AUDIO_BACKEND="pulse"
      AUDIO_CODEC="opus"
      AUDIO_DEVICE=""
      AUDIO_ARGS=()

      check_running_recording() {
        if pgrep -x wl-screenrec >/dev/null; then
          echo "Recording already in progress. Stopping it..."
          pkill -x wl-screenrec
          notify-send -u normal -t 1000 "Screen Recording" "Recording stopped"
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
            -m|--mic)
              INCLUDE_MIC=true
              shift
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

      cleanup_audio() {
        if command -v pactl >/dev/null; then
          echo "Cleaning up audio modules..."
          # Find and unload all modules with our virtual sink name
          local module_ids
          module_ids=$(pactl list short modules | grep "$VIRTUAL_SINK_NAME" | awk '{print $1}')

          if [ -n "$module_ids" ]; then
            echo "$module_ids" | while read -r module_id; do
              pactl unload-module "$module_id" 2>/dev/null || true
            done
            echo "Removed all '$VIRTUAL_SINK_NAME' modules."
          fi
        fi
      }

      prepare_audio() {
        if [ "$INCLUDE_MIC" = true ]; then
          # PipeWire has PulseAudio compatibility, so pactl works
          if ! command -v pactl >/dev/null; then
            echo "Warning: pactl not found. Recording desktop audio only."
            AUDIO_DEVICE="@DEFAULT_AUDIO_SINK@.monitor"
          else
            echo "Setting up combined audio (desktop + microphone)..."

            # Create a virtual null sink to combine audio sources
            pactl load-module module-null-sink sink_name="$VIRTUAL_SINK_NAME" sink_properties=device.description="Screen-Recorder-Combined"

            # Create loopback from default desktop audio output to virtual sink
            pactl load-module module-loopback source="@DEFAULT_AUDIO_SINK@.monitor" sink="$VIRTUAL_SINK_NAME" latency_msec=1

            # Create loopback from default microphone to virtual sink
            pactl load-module module-loopback source="@DEFAULT_AUDIO_SOURCE@" sink="$VIRTUAL_SINK_NAME" latency_msec=1

            # Record from the combined virtual sink's monitor
            AUDIO_DEVICE="''${VIRTUAL_SINK_NAME}.monitor"

            # Set up cleanup on exit
            trap cleanup_audio EXIT INT TERM

            echo "Combined audio setup complete (desktop + microphone)"
          fi
        else
          # Capture system audio (desktop audio) only
          # PulseAudio compatibility layer in PipeWire handles @DEFAULT_AUDIO_SINK@
          AUDIO_DEVICE="@DEFAULT_AUDIO_SINK@.monitor"
        fi

        # Build audio args array using centralized settings
        AUDIO_ARGS=(--audio --audio-backend "$AUDIO_BACKEND" --audio-device "$AUDIO_DEVICE" --audio-codec "$AUDIO_CODEC")
      }

      start_recording_area() {
        echo "Select an area to record..."
        local geometry
        geometry=$(slurp)
        [ -z "$geometry" ] && echo "Selection cancelled" && exit 1

        echo "Starting recording (area)..."
        notify-send -u normal -t 1000 "Screen Recording" "Recording started (area)"
        wl-screenrec \
          --codec "$VIDEO_CODEC" \
          --low-power "$LOW_POWER" \
          -b "$VIDEO_BITRATE" \
          -g "$geometry" \
          "''${AUDIO_ARGS[@]}" \
          -f "$OUTPUT_FILE"
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
        notify-send -u normal -t 1000 "Screen Recording" "Recording started (window)"
        wl-screenrec \
          --codec "$VIDEO_CODEC" \
          --low-power "$LOW_POWER" \
          -b "$VIDEO_BITRATE" \
          -g "$geometry" \
          "''${AUDIO_ARGS[@]}" \
          -f "$OUTPUT_FILE"
      }

      start_recording_output() {
        slurp -h >/dev/null 2>&1 || true

        local monitor=""
        if command -v hyprctl >/dev/null; then
          monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
        fi

        if [ -n "$monitor" ]; then
          echo "Starting recording (output: $monitor)..."
          notify-send -u normal -t 1000 "Screen Recording" "Recording started (output: $monitor)"
          wl-screenrec \
            --codec "$VIDEO_CODEC" \
            --low-power "$LOW_POWER" \
            -b "$VIDEO_BITRATE" \
            -o "$monitor" \
            "''${AUDIO_ARGS[@]}" \
            -f "$OUTPUT_FILE"
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
        pipewire
        pulseaudio
        hyprland
        jq
        libnotify
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
