{
  delib,
  lib,
  pkgs,
  ...
}: let
  k3sTypes = import ./types {inherit lib;};
in
  delib.module {
    name = "services.k3s";
    options = with delib;
      moduleOptions {
        enable = boolOption false;

        cilium.enable = boolOption true;
        flux = {
          enable = boolOption true;
          repositories = k3sTypes.repositoriesOption;
          secrets = k3sTypes.secretsOption;
        };
      };

    nixos.ifEnabled = {cfg, ...}: let
      k3sFlags = lib.concatStringsSep " " (
        [
          "--disable=traefik"
          "--disable=servicelb"
          "--write-kubeconfig-mode=644"
        ]
        ++ lib.optionals cfg.cilium.enable [
          "--disable=flannel"
          "--disable-network-policy"
          "--flannel-backend=none"
          "--disable-kube-proxy"
        ]
      );

      helmfileYaml = ./helmfile.yaml;

      secretManifests = lib.mapAttrs' (name: manifest: {
        name = "k3s-secret-${name}";
        value = {
          inherit (manifest) sopsFile format;
          path = "/var/lib/rancher/k3s/server/manifests/secret-${name}.yaml";
          owner = "root";
          group = "root";
          mode = "0600";
          key = "";
        };
      }) cfg.flux.secrets;

    in {
      environment.sessionVariables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";

      systemd.tmpfiles.rules = lib.mapAttrsToList (name: manifest:
        "L+ /var/lib/rancher/k3s/server/manifests/repo-${name}.yaml - - - - ${manifest.file}"
      ) cfg.flux.repositories;

      sops.secrets = secretManifests;

      services.k3s = {
        enable = true;
        role = "server";
        extraFlags = k3sFlags;
      };

      systemd.services.k3s.postStart = ''
        until ${lib.getExe pkgs.kubectl} --kubeconfig=/etc/rancher/k3s/k3s.yaml get nodes; do
          sleep 2
        done
        chgrp wheel /etc/rancher/k3s/k3s.yaml
        chmod 640 /etc/rancher/k3s/k3s.yaml
      '';

      systemd.services.k3s-bootstrap = lib.mkIf (cfg.cilium.enable || cfg.flux.enable) {
        description = "Bootstrap k3s with Cilium and Flux";
        wantedBy = ["multi-user.target"];
        after = ["k3s.service"];
        requires = ["k3s.service"];
        path = with pkgs; [helmfile kubernetes-helm kubectl git];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          Environment = [
            "KUBECONFIG=/etc/rancher/k3s/k3s.yaml"
            "HOME=/root"
          ];
          WorkingDirectory = "/root";
        };

        script = ''
          until kubectl get nodes; do
            echo "Waiting for k3s..."
            sleep 5
          done

          NODE_IP=$(kubectl get node -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
          echo "Using NODE_IP=$NODE_IP"

          cat > /run/cilium-values.yaml <<EOF
          ipam:
            operator:
              clusterPoolIPv4PodCIDRList:
                - 10.42.0.0/16
          kubeProxyReplacement: true
          k8sServiceHost: "$NODE_IP"
          k8sServicePort: 6443
          operator:
            replicas: 1
          gatewayAPI:
            enabled: true
          EOF

          helmfile --file ${helmfileYaml} sync

          ${lib.getExe pkgs.cilium-cli} status --wait --wait-duration 5m || echo "Cilium still starting, will be ready soon"
        '';
      };

      networking.firewall = {
        checkReversePath = lib.mkIf cfg.cilium.enable false;
        allowedTCPPorts = [6443 10250];
        allowedUDPPorts = lib.mkIf cfg.cilium.enable [8472];
        trustedInterfaces = lib.mkIf cfg.cilium.enable [
          "cni+"
          "cilium_+"
          "cilium_host"
          "cilium_net"
          "lxc+"
          "veth+"
        ];
      };
    };
  }
