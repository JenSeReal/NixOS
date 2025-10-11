{
  config,
  delib,
  ...
}:
delib.host {
  name = "jens-pc";

  nixos = {
    networking.networkmanager.ensureProfiles = {
      environmentFiles = [config.sops.secrets."wifi.env".path];
      profiles = {
        "FRITZ!Box 7590 EW" = {
          connection = {
            id = "FRITZ!Box 7590 EW";
            type = "wifi";
            interface-name = "wlp1s0";
          };
          wifi = {
            mode = "infrastructure";
            ssid = "FRITZ!Box 7590 EW";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$FRITZBox_7590_EW";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          proxy = {};
        };
        "FRITZ!Box 6690 BD" = {
          connection = {
            id = "FRITZ!Box 6690 BD";
            type = "wifi";
            interface-name = "wlp1s0";
          };
          wifi = {
            mode = "infrastructure";
            ssid = "FRITZ!Box 6690 BD";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$FRITZBox_6690_BD";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          proxy = {};
        };
        "PPP-Netz" = {
          connection = {
            id = "PPP-Netz";
            type = "wifi";
            interface-name = "wlp1s0";
          };
          wifi = {
            mode = "infrastructure";
            ssid = "PPP-Netz";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$PPPNetz";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          proxy = {};
        };
      };
    };
  };
}
