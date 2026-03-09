{
  delib,
  ...
}:
delib.module {
  name = "programs.zscaler";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      certPath = strOption "/etc/nix/ca_cert.pem";
    };

  darwin.ifEnabled = {cfg, ...}: {
    environment.variables = {
      NIX_SSL_CERT_FILE = cfg.certPath;
      SSL_CERT_FILE = cfg.certPath;
      REQUEST_CA_BUNDLE = cfg.certPath;
    };

    system.activationScripts.preActivation.text = ''
      if [ ! -f ${cfg.certPath} ]; then
        CERT_FILE="${cfg.certPath}"
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
  };
}
