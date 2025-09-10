{delib, ...}:
delib.overlayModule {
  name = "build-fixes";
  overlay = final: prev: {
    # Disable Harfbuzz tests
    harfbuzz = prev.harfbuzz.overrideAttrs (old: {
      doCheck = false;
    });

    # rsync – disable tests by patching phases
    rsync = prev.rsync.overrideAttrs (old: {
      doCheck = false;
      checkPhase = "true"; # skip running `make test`
      checkTarget = null; # unset the explicit target
      installCheckPhase = ""; # just in case
    });

    # sbcl – prevent its bundled test suite from running
    sbcl = prev.sbcl.overrideAttrs (old: {
      doCheck = false;
      checkPhase = "true";
      installCheckPhase = "";
      makeFlags = (old.makeFlags or []) ++ ["TEST="];
    });

    # Disable libvirt Python bindings checks (openssl.cnf issue)
    python3Packages =
      prev.python3Packages
      // {
        libvirt = prev.python3Packages.libvirt.overrideAttrs (old: {
          doCheck = false;
          installCheckPhase = "";
          pythonImportsCheckPhase = "true";
        });
      };

    pythonPackagesExtensions =
      prev.pythonPackagesExtensions
      ++ [
        (python-final: python-prev: {
          libvirt = python-prev.libvirt.overridePythonAttrs (old: {
            doCheck = false;
            installCheckPhase = "";
            pythonImportsCheckPhase = "true";
          });
        })
      ];
  };
}
