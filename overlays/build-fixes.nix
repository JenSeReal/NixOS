
{
  inputs,
  delib,
  ...
}:
delib.overlayModule {
  name = "build-fixes";
  overlay =
  final: prev: {
    rsync = prev.rsync.overrideAttrs (old: {
      doCheck = false;
    });

    sbcl = prev.sbcl.overrideAttrs (old: {
      doCheck = false;
    });

    harfbuzz = prev.harfbuzz.overrideAttrs (old: {
      doCheck = false;
    });
  };
}
