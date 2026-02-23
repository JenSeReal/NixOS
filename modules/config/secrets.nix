{
  delib,
  inputs,
  homeconfig,
  pkgs,
  ...
}:
delib.module {
  name = "secrets";
  options = with delib;
    moduleOptions {
      defaultSopsFile = allowNull (pathOption null);
      sshKeyPaths = listOfOption path ["/etc/ssh/ssh_host_ed25519_key"];
    };

  nixos.always = {cfg, ...}: {
    imports = [inputs.sops-nix.nixosModules.sops];

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

  home.always = {cfg, ...}: {
    imports = [inputs.sops-nix.homeManagerModules.sops];

    sops = {
      inherit (cfg) defaultSopsFile;
      defaultSopsFormat = "yaml";

      age = {
        generateKey = true;
        keyFile = "${homeconfig.home.homeDirectory}/.config/sops/age/keys.txt";
        sshKeyPaths = ["${homeconfig.home.homeDirectory}/.ssh/id_ed25519"] ++ cfg.sshKeyPaths;
      };
    };
  };
}
