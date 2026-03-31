{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.nix-ld";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs;
    with pkgs; [
      freetype
      fontconfig
      stdenv.cc.cc.lib
      glib
      gtk3
      libGL
      vulkan-loader
      xorg.libX11
      xorg.libXext
      xorg.libXrandr
      xorg.libXi
      xorg.libXcursor
      xorg.libXcomposite
      xorg.libXinerama
      xorg.libxcb
      wayland
      dbus
      openssl
      libpulseaudio
      alsa-lib
      udev
    ];
  };
}
