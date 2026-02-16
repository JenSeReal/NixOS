# K3s Bootstrap Configuration

This directory contains the Helmfile-based bootstrap configuration for the K3s cluster.

## Structure

```
k3s/
├── helmfile.yaml           # Main helmfile manifest (defines releases)
├── values/
│   ├── cilium.yaml        # Cilium CNI configuration
│   └── flux.yaml          # Flux CD configuration
└── manifests/             # Additional Kubernetes manifests (optional)
```

## Components

### Cilium (CNI)
- **Version**: Managed in `helmfile.yaml`
- **Values**: `values/cilium.yaml`
- **Features**:
  - kube-proxy replacement
  - Hubble for network observability
  - Single-node configuration

### Flux CD (GitOps)
- **Version**: Managed in `helmfile.yaml`
- **Values**: `values/flux.yaml`
- **Controllers**:
  - Source Controller
  - Kustomize Controller
  - Helm Controller
  - Notification Controller
  - Image Automation Controller
  - Image Reflection Controller

## Usage

### Deploy/Update
The NixOS module automatically runs helmfile on system rebuild:
```bash
sudo nixos-rebuild switch --flake .#midnight-runner
```

### Manual Operations
```bash
# From this directory
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Preview changes
helmfile diff

# Apply changes
helmfile sync

# List releases
helmfile list

# Update to latest versions
helmfile apply
```

## Renovate Integration

Renovate can automatically update versions in `helmfile.yaml`:

### .renovaterc.json example:
```json
{
  "extends": ["config:base"],
  "helmfile": {
    "fileMatch": ["(^|/)helmfile\\.ya?ml$"]
  },
  "packageRules": [
    {
      "matchDatasources": ["helm"],
      "matchUpdateTypes": ["patch"],
      "automerge": true
    }
  ]
}
```

## Adding New Releases

To add a new Helm release:

1. Add repository to `helmfile.yaml`:
```yaml
repositories:
  - name: jetstack
    url: https://charts.jetstack.io
```

2. Add release:
```yaml
releases:
  - name: cert-manager
    namespace: cert-manager
    createNamespace: true
    chart: jetstack/cert-manager
    version: 1.14.2
    values:
      - values/cert-manager.yaml
    needs:
      - kube-system/cilium
```

3. Create values file: `values/cert-manager.yaml`

## Verification

Check installation status:
```bash
# Cilium
cilium status

# Flux
flux check

# All pods
kubectl get pods -A

# Helmfile status
helmfile status
```
