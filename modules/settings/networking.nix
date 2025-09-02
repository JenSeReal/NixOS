{
  delib,
  host,
  ...
}:
delib.module {
  name = "settings.networking";

  options = with delib;
    moduleOptions {
      nameservers = listOfOption str ["1.1.1.1" "1.0.0.1"];
      hosts = attrsOfOption (listOf str) {};
      hostName = strOption host.name;
    };

  nixos.always = {cfg, ...}: {
    networking = {
      hostName = cfg.hostName;

      firewall.enable = true;
      networkmanager.enable = true;

      dhcpcd.extraConfig = "nohook resolv.conf";
      networkmanager.dns = "none";

      inherit (cfg) hosts nameservers;
    };

    # user.extraGroups = ["networkmanager"];
  };

  darwin.always = {cfg, ...}: {
    system = {
      defaults.smb.NetBIOSName = cfg.hostName;
    };

    networking.hostName = cfg.hostName;
  };
}
