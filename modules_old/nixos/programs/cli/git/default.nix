{ lib, ... }:
{
  imports = [ (lib.snowfall.fs.get-file "modules/common/programs/cli/git/default.nix") ];
}
