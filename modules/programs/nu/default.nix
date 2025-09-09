{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.nu";
  options = delib.singleEnableOption false;

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [nushell];
    environment.shells = with pkgs; [nushell];
  };

  home.ifEnabled = {...}: {
    programs.nushell = {
      enable = true;
      extraConfig = ''
        $env.config = {
          show_banner: false
          completions: {
            case_sensitive: false
            quick: true
            partial: true
            algorithm: "prefix"
          }
        }
      '';
    };
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [nushell];
    environment.shells = with pkgs; [nushell];
  };
}
