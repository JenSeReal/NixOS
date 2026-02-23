{
  delib,
  pkgs,
  ...
}:
delib.deploy {
  name = "midnight-runner";
  rice = "synthwave84";

  nixos = {
    users.defaultUserShell = pkgs.nushell;

    users.users.jfp = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager"];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJnn80mYyCNvHpb+WooP00/YqLf+Jpe1a+Bu5ck0Aaz6 jens@plueddemann.de"
      ];
    };
  };

  myconfig = {
    features = {
      shell-tools.enable = true;
      k8s-tools.enable = true;
    };
    programs = {
      helix.enable = true;
      sudo.enable = true;
      fish.enable = true;
      nh.enable = true;
      nu.enable = true;
    };
    services.k3s = {
      enable = true;
      cilium.enable = true;
      flux = {
        enable = true;
        repositories.nixos = {
          file = ./manifests/nixos-repo.yaml;
        };
        secrets.flux-git-auth = {
          sopsFile = ./secrets/flux-git-auth.yaml;
        };
      };
    };
  };
}
