{delib, ...}:
delib.module {
  name = "hardware.rtl8922ae";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    boot.extraModprobeConfig = ''
      options rtw89_pci disable_aspm=1
    '';
  };
}
