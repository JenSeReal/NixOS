{
  lib,
  inputs,
  snowfall-inputs,
}:

rec {
  ## Override a package's metadata
  ##
  ## ```nix
  ## let
  ##  new-meta = {
  ##    description = "My new description";
  ##  };
  ## in
  ##  lib.override-meta new-meta pkgs.hello
  ## ```
  ##
  #@ Attrs -> Package -> Package
  override-meta =
    meta: package:
    package.overrideAttrs (attrs: {
      meta = (attrs.meta or { }) // meta;
    });

  filterNulls =
    attrs:
    lib.filterAttrs (name: value: value != null) (
      lib.mapAttrs (name: value: if builtins.isAttrs value then filterNulls value else value) attrs
    );
}
