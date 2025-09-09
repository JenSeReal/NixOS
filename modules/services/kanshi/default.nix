{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "services.kanshi";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [
      kanshi
    ];
    user.extraGroups = ["input"];
  };
}
