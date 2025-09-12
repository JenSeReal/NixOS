{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "services.pipewire";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      extra-packages = listOfOption package [
        pkgs.qjackctl
        pkgs.easyeffects
      ];
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages =
      [
        pkgs.pulsemixer
        pkgs.pavucontrol
        pkgs.helvum
      ]
      ++ cfg.extra-packages;

    # sound.enable = true;
    services.pulseaudio = {
      package = pkgs.pulseaudioFull;
    };
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    myconfig.user.extraGroups = ["audio"];
  };
}
