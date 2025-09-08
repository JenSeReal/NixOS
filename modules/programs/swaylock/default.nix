{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.swaylock";
  options = delib.singleEnablxeOption false;

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [swaylock-effects];
    security.pam.services.swaylock = {
      text = ''
        auth sufficient pam_unix.so try_first_pass likeauth nullok
        auth sufficient pam_fprintd.so
        auth include login
      '';
    };
  };
}
