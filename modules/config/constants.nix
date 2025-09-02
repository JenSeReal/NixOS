{delib, ...}:
delib.module {
  name = "constants";

  options = with delib;
    moduleOptions {
      username = readOnly (strOption "jfp");
      userfullname = readOnly (strOption "Jens Plüddemann");
      useremail = readOnly (strOption "jens.plueddemann@cgi.com");
    };

  myconfig.always = {cfg, ...}: {
    args.shared.constants = cfg;
  };
}
