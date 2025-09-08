{
  delib,
  pkgs,
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

  darwin.ifEnabled = {...}: {};
}
