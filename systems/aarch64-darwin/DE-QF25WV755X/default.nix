{
  lib,
  namespace,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  imports = [inputs.ragenix.darwinModules.default];

  environment.systemPackages = with pkgs; [
    google-chrome
    git
    lazygit
    pciutils
    eza
    bat
    # cacert
    fd
    du-dust
    delta
    rm-improved
    ripgrep
    fzf
    zoxide
    killall
    btop
    cyberchef
    discord
    wget
    jetbrains.idea-community-bin
    gimp
    # inkscape
    act
    # postman
    devenv
    seabird
  ];

  # FIXME: migrate settings to hm or other then remove
  system.primaryUser = "jfp";

  # security.pki.certificates = [(builtins.readFile ./zscaler.crt)];

  environment.variables = {
    NIX_SSL_CERT_FILE = "/etc/nix/ca_cert.pem";
    SSL_CERT_FILE = "/etc/nix/ca_cert.pem";
    REQUEST_CA_BUNDLE = "/etc/nix/ca_cert.pem";
  };

  system.activationScripts.preActivation.text = ''
    if [ ! -f /etc/nix/ca_cert.pem ]; then
      CERT_FILE="/etc/nix/ca_cert.pem"
      TMP_FILE="/tmp/ca_cert_combined.pem"

      # Export macOS system certs
      security export -t certs -f pemseq -k /Library/Keychains/System.keychain -o /tmp/certs-system.pem
      security export -t certs -f pemseq -k /System/Library/Keychains/SystemRootCertificates.keychain -o /tmp/certs-root.pem

      # Combine and append Zscaler cert
      cat /tmp/certs-root.pem /tmp/certs-system.pem ${./zscaler.pem} > "$TMP_FILE"

      sudo mkdir -p /etc/nix
      sudo mv "$TMP_FILE" "$CERT_FILE"
    fi
  '';

  JenSeReal = {
    desktop.environments.aerospace = enabled;
    programs.cli = {
      direnv = enabled;
      homebrew = enabled;
      ragenix = enabled;
    };
    programs.gui = {
      browsers.arc = enabled;
      logseq = enabled;
      headlamp = enabled;
      citrix = enabled;
      entertainment.music.spotify = enabled;
      entertainment.gaming.steam = enabled;
    };
    system = enabled;
    themes.stylix = enabled;
    virtualisation.docker = enabled;
  };
}
