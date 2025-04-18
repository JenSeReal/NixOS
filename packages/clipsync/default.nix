{
  lib,
  python3Packages,
  fetchFromGitHub,
  wl-clipboard,
  xclip,
  clipnotify,
}:

python3Packages.buildPythonApplication {
  pname = "clipsync";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "alexankitty";
    repo = "clipsync";
    rev = "1cb89dc3c5929195c47adcdb36b2ca21c49293f0";
    sha256 = "9XsMZ4ZHAQ+Lh9MY86XPL9QqmZSwAXtI1u0bZ3ctfXk=";
  };

  propagatedBuildInputs = with python3Packages; [
    pygobject3
  ];

  nativeBuildInputs = with python3Packages; [
    wrapPython
  ];

  buildInputs = [
    wl-clipboard
    xclip
    clipnotify
  ];

  # Ensure the binary finds its runtime dependencies
  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        wl-clipboard
        xclip
        clipnotify
      ]
    }"
  ];

  # The setup.py script already handles the entry point

  meta = with lib; {
    description = "Tool to synchronize Wayland and X11 clipboards";
    homepage = "https://github.com/alexankitty/clipsync";
    license = licenses.gpl3; # From the LICENSE file in the repo
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "clipsync";
  };
}
