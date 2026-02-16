{
  delib,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "services.k3s";
  options = with delib; let
    inherit (lib) mkOption types;
  in
    moduleOptions {
      enable = boolOption false;

      # K3s role (server, agent, or both)
      role = mkOption {
        type = types.enum ["server" "agent"];
        default = "server";
        description = "K3s role: server (control plane + worker) or agent (worker only)";
      };

      # Server URL for agents
      serverAddr = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Server URL for agent nodes (required for role=agent)";
        example = "https://192.168.1.100:6443";
      };

      # Token path for cluster authentication
      tokenFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Path to file containing the K3s token for cluster authentication";
        example = "/run/secrets/k3s-token";
      };

      # Cilium CNI configuration
      cilium = {
        replaceKubeProxy = boolOption true;
      };

      # Helmfile bootstrap configuration
      helmfile = {
        enable = boolOption false;

        # Path to helmfile.yaml manifest
        manifestPath = mkOption {
          type = types.path;
          default = ./helmfile.yaml;
          description = "Path to helmfile.yaml for bootstrap";
          example = "/home/user/k3s-bootstrap/helmfile.yaml";
        };

        # Condition to verify completion
        completedIf = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "kubectl condition to verify helmfile deployment completion";
          example = "kubectl get deployment -n cert-manager cert-manager";
        };
      };


      # Disable built-in components
      disableComponents = mkOption {
        type = types.listOf types.str;
        default = ["traefik" "servicelb"];
        description = "K3s components to disable";
        example = ["traefik" "servicelb" "local-storage"];
      };

      # Extra flags to pass to K3s
      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Additional flags to pass to K3s";
        example = ["--disable-cloud-controller" "--node-taint key=value:NoExecute"];
      };

      # Cluster CIDR
      clusterCidr = mkOption {
        type = types.str;
        default = "10.42.0.0/16";
        description = "Network CIDR to use for pod IPs";
      };

      # Service CIDR
      serviceCidr = mkOption {
        type = types.str;
        default = "10.43.0.0/16";
        description = "Network CIDR to use for service IPs";
      };
    };

  nixos.ifEnabled = {cfg, ...}: let
    # Disable flannel when using Cilium via helmfile
    disableList =
      cfg.disableComponents
      ++ (
        if cfg.helmfile.enable
        then ["flannel"]
        else []
      );

    # Build disable flags
    disableFlags = map (component: "--disable=${component}") disableList;

    # Cilium flags when enabled via helmfile
    ciliumFlags =
      if cfg.helmfile.enable
      then [
        "--flannel-backend=none"
        "--disable-network-policy"
        "--disable-kube-proxy=${
          if cfg.cilium.replaceKubeProxy
          then "true"
          else "false"
        }"
      ]
      else [];

    # Build all flags
    allFlags =
      disableFlags
      ++ ciliumFlags
      ++ [
        "--cluster-cidr=${cfg.clusterCidr}"
        "--service-cidr=${cfg.serviceCidr}"
      ]
      ++ cfg.extraFlags;

  in {
    # Enable K3s service
    services.k3s = {
      enable = true;
      role = cfg.role;
      serverAddr = cfg.serverAddr;
      tokenFile = cfg.tokenFile;
      extraFlags = lib.strings.concatStringsSep " " allFlags;
    };

    # Enable kubectl, helm, Cilium CLI, Flux, and Helmfile
    environment.systemPackages = with pkgs; [
      kubectl
      kubernetes-helm
      cilium-cli
      hubble
      fluxcd
      helmfile
    ];

    # Set up kubeconfig for root and users
    environment.sessionVariables = {
      KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
    };

    # Allow wheel group to access kubeconfig
    systemd.services.k3s.postStart = ''
      until ${pkgs.kubectl}/bin/kubectl --kubeconfig=/etc/rancher/k3s/k3s.yaml get nodes; do
        echo "Waiting for k3s to be ready..."
        sleep 2
      done

      # Make kubeconfig readable by wheel group
      chgrp wheel /etc/rancher/k3s/k3s.yaml
      chmod 640 /etc/rancher/k3s/k3s.yaml
    '';

    # Bootstrap Helm charts via Helmfile
    systemd.services.helmfile-bootstrap = lib.mkIf (cfg.helmfile.enable && cfg.role == "server") {
      description = "Bootstrap Helm charts via Helmfile";
      wantedBy = ["multi-user.target"];
      after = ["k3s.service"];
      requires = ["k3s.service"];
      path = with pkgs; [helmfile kubectl kubernetes-helm];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Environment = "KUBECONFIG=/etc/rancher/k3s/k3s.yaml";
      };

      script = ''
        # Wait for K3s to be fully ready
        until kubectl get nodes; do
          echo "Waiting for K3s API to be ready..."
          sleep 2
        done

        # Apply helmfile
        echo "Running helmfile sync..."
        helmfile -f ${cfg.helmfile.manifestPath} sync

        # Wait for completion condition if specified
        ${lib.optionalString (cfg.helmfile.completedIf != null) ''
          echo "Waiting for helmfile deployment to complete..."
          until ${cfg.helmfile.completedIf} >/dev/null 2>&1; do
            echo "Still waiting for: ${cfg.helmfile.completedIf}"
            sleep 5
          done
          echo "Helmfile bootstrap completed successfully!"
        ''}
      '';
    };

    # Firewall configuration
    networking.firewall = {
      # K3s server ports
      allowedTCPPorts = lib.mkIf (cfg.role == "server") [
        6443 # Kubernetes API
        10250 # Kubelet metrics
      ];

      # Cilium VXLAN (default overlay)
      allowedUDPPorts = lib.mkIf cfg.helmfile.enable [
        8472 # Cilium VXLAN
      ];

      # Cilium and Hubble ports
      allowedTCPPortRanges = lib.mkIf cfg.helmfile.enable [
        {
          from = 4240;
          to = 4245;
        } # Cilium health & Hubble
      ];

      # Allow traffic on Cilium interfaces
      trustedInterfaces = lib.mkIf cfg.helmfile.enable ["cilium_+" "lxc+"];
    };

    # Enable IP forwarding and bridge netfilter
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
      "net.bridge.bridge-nf-call-iptables" = 1;
      "net.bridge.bridge-nf-call-ip6tables" = 1;
      # Increase inotify limits for Kubernetes
      "fs.inotify.max_user_instances" = 524288;
      "fs.inotify.max_user_watches" = 524288;
    };

    # Load required kernel modules
    boot.kernelModules = ["br_netfilter" "overlay"];
  };
}
