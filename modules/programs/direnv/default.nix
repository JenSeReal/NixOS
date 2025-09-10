{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.direnv";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    home.packages = with pkgs.unstable; [devenv];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs.unstable; [
      devenv
      direnv
      nix-direnv
    ];
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs.unstable; [
      devenv
      direnv
      nix-direnv
    ];
  };
}
