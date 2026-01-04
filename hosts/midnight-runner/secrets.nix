{inputs, ...}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ./secrets/secrets.yml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  };
}
