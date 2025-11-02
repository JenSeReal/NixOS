{
  delib,
  pkgs,
  config,
  ...
}:
delib.module {
  name = "hardware.framework";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    boot.kernelParams = ["microcode.amd_sha_check=off"];

    boot.extraModulePackages = with config.boot.kernelPackages; [framework-laptop-kmod];

    environment.systemPackages = with pkgs; [
      framework-tool
      fw-ectool
    ];

    services = {
      libinput.enable = true;
      printing.enable = true;
    };
  };

  # myconfig = {
  #   hardware.fingerprint.enable = true;
  #   services.fwupd.enable = true;
  # };
}
