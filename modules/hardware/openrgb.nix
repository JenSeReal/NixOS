{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "hardware.openrgb";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    # Allow SMBus/i2c access for RAM RGB control
    # i2c-dev: exposes i2c buses to userspace
    # i2c-piix4: AMD SMBus driver (required for RAM RGB on AMD platforms)
    boot.kernelModules = ["i2c-dev" "i2c-piix4"];
    boot.kernelParams = ["acpi_enforce_resources=lax"];

    # Add user to i2c group for SMBus access
    myconfig.user.extraGroups = ["i2c"];

    services.hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
      motherboard = "amd";
    };
  };
}
