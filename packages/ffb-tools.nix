{delib, ...}:
delib.package {
  name = "ffb-tools";

  package = {
    lib,
    fetchFromGitHub,
    gcc,
    makeWrapper,
    glibc,
    multiStdenv,
    ...
  }:
    multiStdenv.mkDerivation rec {
      pname = "ffbtools";
      version = "ebc4702f4fa6284f641d3b58b8f3e234244f9deb";

      src = fetchFromGitHub {
        owner = "berarma";
        repo = "ffbtools";
        rev = version;
        sha256 = lib.fakeSha256;
      };

      buildInputs = [
        gcc
        glibc
        makeWrapper
      ];

      makeFlags = [
        "CC=${multiStdenv.cc}/bin/gcc"
        "CXX=${multiStdenv.cc}/bin/g++"
      ];

      doCheck = false;

      installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/lib
        cp ffbwrap ffbplay $out/bin/
        if [ -f libffbwrapper.so ]; then
          cp libffbwrapper.so $out/lib/
        fi
      '';

      meta = with lib; {
        description = "Tools to debug and test force feedback (FFB) in applications.";
        homepage = "https://github.com/berarma/ffbtools";
        license = licenses.gpl2Plus;
        maintainers = [maintainers.jensereal];
        platforms = platforms.linux;
      };
    };
}
