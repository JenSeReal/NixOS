{
  delib,
  ...
}:
delib.module {
  name = "hardware.rtl8822ce";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    boot.extraModprobeConfig = ''
      options rtw88_pci disable_aspm=1
      options rtw88_core disable_lps_deep=1
    '';
  };
}
