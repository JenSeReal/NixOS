{
  delib,
  lib,
  ...
}:
delib.module {
  name = "features.k8s-tools";
  options = with delib; let
    inherit (lib) mkOption types;
  in
    moduleOptions {
      enable = boolOption false;

      # Kubectl alias groups
      kubectl = boolOption true; # k for kubectl
      get = boolOption true; # kg, kga for kubectl get
      describe = boolOption true; # kd, kda for kubectl describe
      delete = boolOption true; # kdel for kubectl delete
      apply = boolOption true; # ka for kubectl apply
      logs = boolOption true; # kl, klf for kubectl logs
      exec = boolOption true; # kex for kubectl exec
      port-forward = boolOption true; # kpf for kubectl port-forward
      contexts = boolOption true; # kctx, kns for context/namespace switching
      edit = boolOption true; # ke for kubectl edit
      scale = boolOption true; # ks for kubectl scale
      rollout = boolOption true; # kr* for kubectl rollout commands

      # Additional helpful aliases
      extraAliases = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = "Additional custom k8s aliases";
        example = {
          kgp = "kubectl get pods";
          kgs = "kubectl get services";
        };
      };
    };

  nixos.ifEnabled = {...}: {
    myconfig = {
      programs = {
        kubectl.enable = true;
        awscli.enable = true;
        fluxcd.enable = true;
        k9s.enable = true;
        cloudlens.enable = true;
        crossplane.enable = true;
        opentofu.enable = true;
      };
    };
  };

  home.ifEnabled = {cfg, ...}: let
    # Helper to conditionally add aliases
    mkAlias = condition: aliases:
      if condition
      then aliases
      else {};
  in {
    programs.zsh.shellAliases =
      mkAlias cfg.kubectl {
        k = "kubectl";
      }
      // mkAlias cfg.get {
        kg = "kubectl get";
        kga = "kubectl get -A";
        kgp = "kubectl get pods";
        kgpa = "kubectl get pods -A";
        kgd = "kubectl get deployments";
        kgda = "kubectl get deployments -A";
        kgs = "kubectl get services";
        kgsa = "kubectl get services -A";
        kgn = "kubectl get nodes";
        kgns = "kubectl get namespaces";
      }
      // mkAlias cfg.describe {
        kd = "kubectl describe";
        kda = "kubectl describe -A";
        kdp = "kubectl describe pod";
        kdd = "kubectl describe deployment";
        kds = "kubectl describe service";
      }
      // mkAlias cfg.delete {
        kdel = "kubectl delete";
        kdelp = "kubectl delete pod";
        kdeld = "kubectl delete deployment";
        kdels = "kubectl delete service";
      }
      // mkAlias cfg.apply {
        ka = "kubectl apply";
        kaf = "kubectl apply -f";
      }
      // mkAlias cfg.logs {
        kl = "kubectl logs";
        klf = "kubectl logs -f";
        klp = "kubectl logs -p";
      }
      // mkAlias cfg.exec {
        kex = "kubectl exec -it";
        keti = "kubectl exec -it";
      }
      // mkAlias cfg.port-forward {
        kpf = "kubectl port-forward";
      }
      // mkAlias cfg.contexts {
        kctx = "kubectl config get-contexts";
        kctxu = "kubectl config use-context";
        kns = "kubectl config set-context --current --namespace";
      }
      // mkAlias cfg.edit {
        ke = "kubectl edit";
      }
      // mkAlias cfg.scale {
        ks = "kubectl scale";
      }
      // mkAlias cfg.rollout {
        kr = "kubectl rollout";
        krr = "kubectl rollout restart";
        krs = "kubectl rollout status";
        krh = "kubectl rollout history";
        kru = "kubectl rollout undo";
      }
      // cfg.extraAliases;

    programs.bash.shellAliases =
      mkAlias cfg.kubectl {
        k = "kubectl";
      }
      // mkAlias cfg.get {
        kg = "kubectl get";
        kga = "kubectl get -A";
        kgp = "kubectl get pods";
        kgpa = "kubectl get pods -A";
        kgd = "kubectl get deployments";
        kgda = "kubectl get deployments -A";
        kgs = "kubectl get services";
        kgsa = "kubectl get services -A";
        kgn = "kubectl get nodes";
        kgns = "kubectl get namespaces";
      }
      // mkAlias cfg.describe {
        kd = "kubectl describe";
        kda = "kubectl describe -A";
        kdp = "kubectl describe pod";
        kdd = "kubectl describe deployment";
        kds = "kubectl describe service";
      }
      // mkAlias cfg.delete {
        kdel = "kubectl delete";
        kdelp = "kubectl delete pod";
        kdeld = "kubectl delete deployment";
        kdels = "kubectl delete service";
      }
      // mkAlias cfg.apply {
        ka = "kubectl apply";
        kaf = "kubectl apply -f";
      }
      // mkAlias cfg.logs {
        kl = "kubectl logs";
        klf = "kubectl logs -f";
        klp = "kubectl logs -p";
      }
      // mkAlias cfg.exec {
        kex = "kubectl exec -it";
        keti = "kubectl exec -it";
      }
      // mkAlias cfg.port-forward {
        kpf = "kubectl port-forward";
      }
      // mkAlias cfg.contexts {
        kctx = "kubectl config get-contexts";
        kctxu = "kubectl config use-context";
        kns = "kubectl config set-context --current --namespace";
      }
      // mkAlias cfg.edit {
        ke = "kubectl edit";
      }
      // mkAlias cfg.scale {
        ks = "kubectl scale";
      }
      // mkAlias cfg.rollout {
        kr = "kubectl rollout";
        krr = "kubectl rollout restart";
        krs = "kubectl rollout status";
        krh = "kubectl rollout history";
        kru = "kubectl rollout undo";
      }
      // cfg.extraAliases;

    programs.fish.shellAliases =
      mkAlias cfg.kubectl {
        k = "kubectl";
      }
      // mkAlias cfg.get {
        kg = "kubectl get";
        kga = "kubectl get -A";
        kgp = "kubectl get pods";
        kgpa = "kubectl get pods -A";
        kgd = "kubectl get deployments";
        kgda = "kubectl get deployments -A";
        kgs = "kubectl get services";
        kgsa = "kubectl get services -A";
        kgn = "kubectl get nodes";
        kgns = "kubectl get namespaces";
      }
      // mkAlias cfg.describe {
        kd = "kubectl describe";
        kda = "kubectl describe -A";
        kdp = "kubectl describe pod";
        kdd = "kubectl describe deployment";
        kds = "kubectl describe service";
      }
      // mkAlias cfg.delete {
        kdel = "kubectl delete";
        kdelp = "kubectl delete pod";
        kdeld = "kubectl delete deployment";
        kdels = "kubectl delete service";
      }
      // mkAlias cfg.apply {
        ka = "kubectl apply";
        kaf = "kubectl apply -f";
      }
      // mkAlias cfg.logs {
        kl = "kubectl logs";
        klf = "kubectl logs -f";
        klp = "kubectl logs -p";
      }
      // mkAlias cfg.exec {
        kex = "kubectl exec -it";
        keti = "kubectl exec -it";
      }
      // mkAlias cfg.port-forward {
        kpf = "kubectl port-forward";
      }
      // mkAlias cfg.contexts {
        kctx = "kubectl config get-contexts";
        kctxu = "kubectl config use-context";
        kns = "kubectl config set-context --current --namespace";
      }
      // mkAlias cfg.edit {
        ke = "kubectl edit";
      }
      // mkAlias cfg.scale {
        ks = "kubectl scale";
      }
      // mkAlias cfg.rollout {
        kr = "kubectl rollout";
        krr = "kubectl rollout restart";
        krs = "kubectl rollout status";
        krh = "kubectl rollout history";
        kru = "kubectl rollout undo";
      }
      // cfg.extraAliases;
  };
}
