{delib, ...}: let
  inherit (delib) extension maintainers;
in
  extension {
    name = "packages";
    description = "Registers custom packages with platform compatibility handled via meta.platforms";
    maintainers = with maintainers; [JenSeReal];

    config = final: prev: {
      moduleNamePrefix = "packages";
    };

    libExtension = config: final: _: {
      packageModule = {
        name,
        package,
        withPrefix ? true,
      }: let
        # Create the overlay that will call the package function with nixpkgs dependencies
        pkgsOverlay = final: prev: {
          ${name} = final.callPackage package {};
        };
      in
        final.module {
          name =
            if withPrefix
            then "${config.moduleNamePrefix}.${name}"
            else name;

          # Register overlay on both platforms
          # Platform compatibility is handled by the package's meta.platforms attribute
          nixos.always = {
            nixpkgs.overlays = [pkgsOverlay];
          };
        };
    };
  }
