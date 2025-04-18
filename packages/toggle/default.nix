{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenv.mkDerivation {
  name = "toggle";
  version = "0.1.0";

  dontUnpack = true;

  buildInputs = with pkgs; [
    bash
    procps
  ];

  installPhase = ''
    mkdir -p $out/bin

    cat > $out/bin/toggle << 'EOF'
    #!/usr/bin/env bash

    # toggle - Utility to toggle processes on and off, optimized for NixOS store paths
    #
    # Usage: toggle COMMAND [ARGS...]

    set -e

    if [ -z "$1" ]; then
      echo "Usage: $0 <process_name> [arguments...]"
      exit 1
    fi

    # Extract just the binary name from the full path
    BINARY_PATH="$1"
    BINARY_NAME=$(basename "$BINARY_PATH")

    # Check if process is running using the binary name
    if pgrep -x "$BINARY_NAME" > /dev/null 2>&1; then
      echo "Stopping $BINARY_NAME"
      pkill -15 -x "$BINARY_NAME"
      sleep 0.5  # Give it a moment to terminate gracefully
    else
      echo "Starting $BINARY_NAME with args: ''${@:2}"
      # Use setsid to run in a new session, preventing termination when toggle exits
      setsid "$@" > /dev/null 2>&1 &
    fi
    EOF

    chmod +x $out/bin/toggle
  '';

  meta = with pkgs.lib; {
    description = "A utility to toggle processes on and off";
    longDescription = ''
      Toggle is a simple bash script that checks if a specified process
      is running by its binary name. If it is, the process will be terminated.
      If not, the process will be started with the provided arguments.

      Optimized for working with NixOS store paths.
    '';
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "toggle";
  };
}
