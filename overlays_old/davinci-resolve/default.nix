{ ... }:

old: prev: {
  davinci-resolve = prev.davinci-resolve.override (old: {
    buildFHSEnv =
      a:
      (old.buildFHSEnv (
        a
        // {
          extraBwrapArgs = a.extraBwrapArgs ++ [ "--bind /run/opengl-driver/etc/OpenCL /etc/OpenCL" ];
        }
      ));
  });
}
