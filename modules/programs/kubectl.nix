{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.kubectl";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.kubectl;
      plugins = with delib; {
        kns = boolOption true;
        viewSecret = boolOption true;
        explore = boolOption true;
        graph = boolOption true;
        tree = boolOption true;
        neat = boolOption true;
        krew = boolOption true;
        dfPv = boolOption true;
      };
      helm = boolOption true;
      polaris = boolOption true;
      kubelogin = boolOption true;
      kubeloginOidc = boolOption true;
      kustomize = boolOption true;
      kustomizeSops = boolOption true;
    };

  nixos.ifEnabled = {cfg, ...}: let
    plugins = with pkgs; [
      (lib.optional cfg.plugins.kns kns)
      (lib.optional cfg.plugins.viewSecret kubectl-view-secret)
      (lib.optional cfg.plugins.explore kubectl-explore)
      (lib.optional cfg.plugins.graph kubectl-graph)
      (lib.optional cfg.plugins.tree kubectl-tree)
      (lib.optional cfg.plugins.neat kubectl-neat)
      (lib.optional cfg.plugins.krew krew)
      (lib.optional cfg.plugins.dfPv kubectl-df-pv)
    ];
    tools = with pkgs; [
      (lib.optional cfg.helm kubernetes-helm)
      (lib.optional cfg.polaris kubernetes-polaris)
      (lib.optional cfg.kubelogin kubelogin)
      (lib.optional cfg.kubeloginOidc kubelogin-oidc)
      (lib.optional cfg.kustomize kustomize)
      (lib.optional cfg.kustomizeSops kustomize-sops)
    ];
  in {
    environment.systemPackages = [cfg.package] ++ (pkgs.lib.flatten (plugins ++ tools));
  };
}
