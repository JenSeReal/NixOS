{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "hardware.audio";
  options = delib.singleEnableOption false;

  darwin.always = {
    system.defaults = {
      NSGlobalDomain = {
        "com.apple.sound.beep.feedback" = 0;
        "com.apple.sound.beep.volume" = 0.0;
      };
      ".GlobalPreferences"."com.apple.sound.beep.sound" = null;
    };
  };

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [pulsemixer];
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      jack.enable = true;
    };
    services.pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = ["hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag"];
      };
    };
    myconfig.user.extraGroups = ["audio"];
  };
}
