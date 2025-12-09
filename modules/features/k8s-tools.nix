{delib, ...}:
delib.module {
  name = "features.k8s-tools";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
    };

  nixos.ifEnabled = {...}: {
    myconfig = {
      programs = {
        kubectl.enable = true;
        awscli.enable = true;
        fluxcd.enable = true;
        k9s.enable = true;
        cloudlens.enable = true;
        crossplane.enable = true;
        opentofu.enable = true;
      };
    };
  };
}
