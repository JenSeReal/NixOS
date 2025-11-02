{
  config,
  delib,
  homeconfig,
  ...
}:
delib.host {
  name = "jens-pc";

  nixos = {
    sops.secrets = {
      "wifi.env" = {
        sopsFile = ../common/secrets/wifi.yaml;
      };
      github_token = {
        sopsFile = ../common/secrets/github-token.yaml;
      };
    };

    sops.templates."github-access-tokens.conf".content = ''
      extra-access-tokens = github.com=${config.sops.placeholder.github_token}
    '';

    nix.extraOptions = ''
      !include ${config.sops.templates."github-access-tokens.conf".path}
    '';
  };

  home = {
    sops.secrets = {
      "ssh/jfp.one" = {
        sopsFile = ./secrets/ssh.yaml;
        path = "${homeconfig.home.homeDirectory}/.ssh/hosts/jfp.one";
      };
    };
  };
}
