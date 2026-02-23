{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
  hidapi,
  libserialport,
  libxml2,
  argtable,
  libconfig,
  libpulseaudio,
  portaudio,
  jansson,
  libuv,
  libxdg_basedir,
  lua5_3,
}:

stdenv.mkDerivation rec {
  pname = "monocoque";
  version = "d08ebfa";

  src = fetchFromGitHub {
    owner = "Spacefreak18";
    repo = "monocoque";
    rev = version;
    sha256 = "sha256-aXl4jDQf/+jG2gK9S79bfAS1ugmYmWeWT3MoV2S0opY=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace src/monocoque/helper/parameters.c \
      --replace-warn 'argtable2.h' 'argtable3.h'

    substituteInPlace $(find . -name CMakeLists.txt) \
      --replace-warn 'argtable2' 'argtable3' \
      --replace-warn 'LIBUSB_INCLUDE_DIR /usr/include' 'LIBUSB_INCLUDE_DIR ${lib.getDev libusb1}/include' \
      --replace-warn 'LIBXML_INCLUDE_DIR /usr/include' 'LIBXML_INCLUDE_DIR ${lib.getDev libxml2}/include'
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib/udev}
    install -m755 -D monocoque $out/bin/monocoque

    cp -r $src/udev $out/lib/udev
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libusb1
    hidapi
    libserialport
    libxml2
    argtable
    libconfig
    libpulseaudio
    portaudio
    jansson
    libuv
    libxdg_basedir
    lua5_3
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=RELEASE"
    "-DCMAKE_INSTALL_PREFIX=$(out)"
    "-DUSE_PULSEAUDIO=yes"
    "-Wno-dev"
    "-DLUA_LIBRARIES=${lua5_3}/lib/liblua.so"
    "-DLUA_INCLUDE_DIR=${lua5_3}/include"
  ];

  meta = {
    description = "A device manager for driving and flight simulators, for use with common simulator software titles";
    homepage = "https://github.com/Spacefreak18/monocoque";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ JenSeReal ];
    mainProgram = "monocoque";
    platforms = lib.platforms.all;
  };
}