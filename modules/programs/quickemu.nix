{
  delib,
  pkgs,
  ...
}:
#let
# fix_iso_script = pkgs.writeShellScript "quickemu_fix_windows_iso.sh" ''
#   export VM_PATH="$HOME/windows-11"
#   echo "Fixing virtio iso"
#   mkdir -p "''${VM_PATH}/virtio-cd"
#   ${lib.getExe pkgs.p7zip} x "''${VM_PATH}/virtio-win.iso" -o"''${VM_PATH}/virtio-cd" -bso0 -bsp0
#   [[ -d "''${VM_PATH}/virtio-cd" && "$(ls -A "''${VM_PATH}/virtio-cd")" ]] || { echo "Error: Extraction of virtio-cd failed!"; exit 1; }
#   pushd "''${VM_PATH}/virtio-cd"
#   find . -mindepth 1 -maxdepth 1 ! -name "NetKVM" ! -name "vioscsi" ! -name "viostor" ! -name "*.msi" ! -name "*.exe" -exec rm -rf {} +
#   popd
#   rm -rf "''${VM_PATH}/virtio-win.iso"
#   ${lib.getExe' pkgs.cdrtools "mkisofs"} -quiet -o "''${VM_PATH}/virtio-win.iso" -V "fixed-cd" -J -R "''${VM_PATH}/virtio-cd"
# '';
# in
delib.module {
  name = "programs.quickemu";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs.unstable; [quickemu];
  };
}
