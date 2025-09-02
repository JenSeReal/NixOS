{
  delib,
  config,
  ...
}:
with delib; {
  # display = submodule {
  #   options = {
  #     enable = boolOption true;
  #     touchscreen = boolOption false;
  #     name = noDefault (strOption null);
  #     primary = boolOption (builtins.length config.displays == 1);
  #     refreshRate = intOption 60;
  #     width = intOption 1920;
  #     height = intOption 1080;
  #     x = intOption 0;
  #     y = intOption 0;
  #   };
  # };
}
