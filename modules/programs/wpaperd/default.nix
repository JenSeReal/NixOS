{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.wpaperd";
  options = delib.singleEnablxeOption false;

  home.ifEnabled = {
    programs.wpaperd = {
      enable = true;
      settings = {
        default = {
          path = "/home/jfp/Pictures/wallpaper";
        };
      };
    };
  };

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [wpaperd];
  };
}
