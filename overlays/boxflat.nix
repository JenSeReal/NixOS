{
  lib,
  delib,
  ...
}:
delib.overlayModule {
  name = "boxflat";
  overlay = final: prev: {
    boxflat = prev.boxflat.overrideAttrs (oldAttrs: {
      version = "1.35.4";

      src = final.fetchFromGitHub {
        owner = "Lawstorant";
        repo = "boxflat";
        rev = "v1.35.4";
        hash = "sha256-xgQ9J3UF+6ElFlR96IaXkz9nzCSwwF3NxgUMDJk+FRM=";
      };

      preBuild =
        (oldAttrs.preBuild or "")
        + ''
          # Wrap the module-level code in a main() function to fix the entry point
          substituteInPlace entrypoint.py \
            --replace-fail 'import boxflat.app as app

app.MyApp(data_path,
    config_path,
    args.dry_run,
    args.custom,
    args.autostart,
    application_id="io.github.lawstorant.boxflat"
).run()' 'def main():
    import boxflat.app as app

    app.MyApp(data_path,
        config_path,
        args.dry_run,
        args.custom,
        args.autostart,
        application_id="io.github.lawstorant.boxflat"
    ).run()'
        '';
    });
  };
}
