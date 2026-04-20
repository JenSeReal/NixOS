{
  delib,
  pkgs,
  inputs,
  ...
}:
delib.host {
  name = "jens-pc";

  rice = "synthwave84";
  type = "laptop";

  nixos = {
    imports = [inputs.nixos-hardware.nixosModules.framework-13-7040-amd];

    users.defaultUserShell = pkgs.nushell;

    # TODO: Remove in a few days

    boot.initrd.luks.cryptoModules = [
      "aes"
      # "aes_generic"
      "blowfish"
      "twofish"
      "serpent"
      "cbc"
      "xts"
      "lrw"
      "sha1"
      "sha256"
      "sha512"
      "af_alg"
      "algif_skcipher"
      "cryptd"
      "input_leds" # for capslock LED on most keyboards in case decryption requires password
    ];
  };

  myconfig = {
    features.desktop-environments.hyprland.enable = true;
    features.shell-tools.enable = true;
    hardware = {
      keychron.enable = true;
      moza-r12.enable = true;
    };
    programs = {
      bitwarden.enable = true;
      codium.enable = true;
      DataLink.enable = true;
      davinci-resolve.enable = true;
      gamemode.enable = true;
      helix.enable = true;
      sudo.enable = true;
      fish.enable = true;
      ffmpeg.enable = true;
      gimp.enable = true;
      inkscape.enable = true;
      mpv.enable = true;
      neovide.enable = true;
      nh.enable = true;
      nix-ld.enable = true;
      nu.enable = true;
      podman.enable = true;
      quickemu.enable = true;
      steam.enable = true;
      vesktop.enable = true;
      virt-manager.enable = true;
      vtracer.enable = true;
      wezterm.enable = true;
      zed.enable = true;
    };
  };
}
