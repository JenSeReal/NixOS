{
  delib,
  lib,
  ...
}:
delib.deploy {
  name = "midnight-runner";
  hostname = "152.53.135.216";
  sshPort = 50022;

  nixos = {
    networking.hostName = "midnight-runner";
    networking.useDHCP = lib.mkDefault true;

    services.openssh = {
      enable = true;
      ports = [50022];
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [80 443 50022];
    };
  };
}
