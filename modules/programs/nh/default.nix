{
  delib,
  pkgs,
  config,
  ...
}:
delib.module {
  name = "programs.nh";
  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: {
    programs.nh = {
      enable = true;
      # clean.enable = true;
      # clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "${config.home.homeDirectory}/nixos";
    };
  };

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [nh];
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [nh];
  };
}
