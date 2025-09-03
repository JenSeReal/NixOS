{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.firefox";

  options = with delib; moduleOptions {
    enable = boolOption false;
    extraConfig = strOption "";
    settings = attrsOption {};
    gpuAcceleration = boolOption false;
    hardwareDecoding = boolOption false;
    userChrome = strOption "";
  };

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [
      firefox-bin
    ];
  };

  home.ifEnabled = {...}: {
    programs.firefox = with pkgs; {
      enable = true;
      package = firefox-bin;
    };
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [
      firefox-bin
    ];
  };
}
