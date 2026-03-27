{delib, ...}:
delib.package {
  name = "clipsync";

  package = {
    lib,
    pkgs,
    python3Packages,
    fetchFromGitHub,
    wl-clipboard,
    xclip,
    clipnotify,
    ...
  }:
    python3Packages.buildPythonApplication {
      pname = "clipsync";
      version = "1.0.0";

      pyproject = true;
      build-system = with pkgs.python3Packages; [
        setuptools
      ];

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

      makeWrapperArgs = [
        "--prefix PATH : ${
          lib.makeBinPath [
            wl-clipboard
            xclip
            clipnotify
          ]
        }"
      ];

      meta = with lib; {
        description = "Tool to synchronize Wayland and X11 clipboards";
        homepage = "https://github.com/alexankitty/clipsync";
        license = licenses.gpl3;
        platforms = platforms.linux;
        maintainers = [];
        mainProgram = "clipsync";
      };
    };
}
