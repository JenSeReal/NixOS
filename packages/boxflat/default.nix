{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  gtk4,
  libadwaita,
  cairo,
  gobject-introspection,
  pkg-config,
  wrapGAppsHook4,
  pkexec ? null,
  makeWrapper,
  graphene,
  glib,
  pango,
  gdk-pixbuf,
}:
let
  version = "v1.30.0";
  pythonEnv = python3.withPackages (
    ps: with ps; [
      pyyaml
      psutil
      pyserial
      pycairo
      pygobject3
      evdev
    ]
  );
in
stdenv.mkDerivation {
  inherit version;
  pname = "boxflat";
  src = fetchFromGitHub {
    owner = "lawstorant";
    repo = "boxflat";
    rev = version;
    sha256 = "6fzz3pq9fHoeGMT1Vz5Y8pKLdrprQEV5kLiZt7uJ1KI=";
  };
  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    gobject-introspection
    makeWrapper
    pythonEnv
  ];
  buildInputs = [
    gtk4
    libadwaita
    cairo
    glib
    graphene
    pango
    gdk-pixbuf
  ];
  installPhase = ''
    # Create necessary directories
    mkdir -p $out/bin
    mkdir -p $out/lib/python${pythonEnv.pythonVersion}/site-packages/boxflat
    mkdir -p $out/share/boxflat/data
    mkdir -p $out/share/applications
    mkdir -p $out/share/metainfo
    mkdir -p $out/share/icons/hicolor/scalable/apps
    mkdir -p $out/lib/udev/rules.d

    cp io.github.lawstorant.boxflat.desktop $out/share/applications/
    cp io.github.lawstorant.boxflat.metainfo.xml $out/share/metainfo/
    cp icons/scalable/apps/io.github.lawstorant.boxflat.svg $out/share/icons/hicolor/scalable/apps/io.github.lawstorant.boxflat.svg

    # Copy all project files to site-packages
    cp -r ./* $out/lib/python${pythonEnv.pythonVersion}/site-packages/boxflat/

    # Install the data folder to the correct location
    cp -r data/* $out/share/boxflat/data/

    # Install udev rules
    cp udev/99-boxflat.rules $out/lib/udev/rules.d/99-boxflat.rules

    # Create wrapper script
    makeWrapper ${pythonEnv}/bin/python $out/bin/boxflat \
      --set PYTHONPATH "$out/lib/python${pythonEnv.pythonVersion}/site-packages:${pythonEnv}/${pythonEnv.sitePackages}" \
      --set GI_TYPELIB_PATH "$GI_TYPELIB_PATH:${glib}/lib/girepository-1.0:${gtk4}/lib/girepository-1.0:${libadwaita}/lib/girepository-1.0:${graphene}/lib/girepository-1.0:${glib}/lib/girepository-1.0:${pango}/lib/girepository-1.0:${gdk-pixbuf}/lib/girepository-1.0" \
      --add-flags "$out/lib/python${pythonEnv.pythonVersion}/site-packages/boxflat/entrypoint.py --data-path $out/share/boxflat/data"
  '';

  meta = with lib; {
    homepage = "https://github.com/Lawstorant/boxflat";
    changelog = "https://github.com/Lawstorant/boxflat/releases/tag/${version}";
    description = "Boxflat for Moza Racing. Control your Moza gear settings!";
    mainProgram = "boxflat";
    license = licenses.gpl3;
    maintainers = [ maintainers.jensereal ];
    platforms = platforms.unix;
  };
}
