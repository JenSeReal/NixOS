{
  delib,
  pkgs,
  config,
  inputs,
  ...
}:
delib.module {
  name = "programs.sops";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      defaultSopsFile = allowNull (pathOption null);
      sshKeyPaths = listOfOption path ["/etc/ssh/ssh_host_ed25519_key"];
    };

  darwin.ifEnabled = {...}: {};

  home.always = {imports = [inputs.sops-nix.homeManagerModules.sops];};
  home.ifEnabled = {cfg, ...}: {
    sops = {
      inherit (cfg) defaultSopsFile;
      defaultSopsFormat = "yaml";

      age = {
        generateKey = true;
        keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"] ++ cfg.sshKeyPaths;
      };
    };

    # home.activation.setupEtc = config.lib.dag.entryAfter ["writeBoundary"] ''
    #   /run/current-system/sw/bin/systemctl start --user sops-nix
    # '';
  };

  nixos.always = {imports = [inputs.sops-nix.nixosModules.sops];};
  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = with pkgs; [
      age
      sops
      ssh-to-age
    ];

    sops = {
      inherit (cfg) defaultSopsFile;

      age = {
        generateKey = true;
        keyFile = "/var/lib/sops-nix/key.txt";
        inherit (cfg) sshKeyPaths;
      };
    };
  };
}
