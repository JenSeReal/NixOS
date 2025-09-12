{
  pkgs,
  lib,
  stdenv,
  kernel ? pkgs.linuxPackages_latest.kernel,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "new-lg4ff";
  version = "latest";

  src = fetchFromGitHub {
    owner = "berarma";
    repo = "new-lg4ff";
    rev = "master";
    sha256 = "sha256-90PnQDGwp94ELvWx6p8QiZucYmTbH3N0GiZbj3fo25g=";
  };

  preBuild = ''
    substituteInPlace Makefile --replace "modules_install" "INSTALL_MOD_PATH=$out modules_install"
    sed -i '/depmod/d' Makefile
    sed -i "10i\\\trmmod hid-logitech 2> /dev/null || true" Makefile
    sed -i "11i\\\trmmod hid-logitech-new 2> /dev/null || true" Makefile
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KVERSION=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  meta = with lib; {
    description = "Experimental Logitech force feedback module for Linux";
    homepage = "https://github.com/berarma/new-lg4ff";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ matthiasbenaets ];
    platforms = platforms.linux;
    broken = stdenv.hostPlatform.isAarch64;
  };
}
