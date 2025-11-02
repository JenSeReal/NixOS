{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.kickoff";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    xdg.configFile."kickoff/config.toml".source = ./config.toml;
    home.packages = with pkgs; [
      kickoff
    ];
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [kickoff];
  };
}
