# GitOps-Managed Kubernetes Platform

## Overview

This repository contains shell scripts and configurations for managing a GitOps-based Kubernetes platform using ArgoCD, Traefik, MetalLB, Grafana, Prometheus, and Loki.

## Architecture

```
┌─────────────────────────────────────┐
│   K3s Cluster                        │
├────────────┬──────────────────────┘
│
├─ GitOps        ├─ Service Mesh  ├─ Monitoring
│  ├─ ArgoCD         ├─ Traefik       ├─ Prometheus
│  └─ Flux           └─ MetalLB       ├─ Grafana
│                                   └─ Loki
│
└─ Storage        ├─ Networking
   ├─ Local Volumes  ├─ CNI
   └─ NFS            └─ Network Policies
```

## Prerequisites

- Linux host (Ubuntu 20.04+)
- kubectl >= 1.24
- Helm >= 3.12
- Git
- Basic Kubernetes knowledge

## Quick Start

### 1. Install K3s

```bash
# Run K3s installation script
bash scripts/install-k3s.sh

# Verify installation
kubectl cluster-info
kubectl get nodes
```

### 2. Install Core Components

```bash
# Install ArgoCD
bash scripts/install-argocd.sh

# Install monitoring stack
bash scripts/install-monitoring.sh

# Install ingress controller
bash scripts/install-traefik.sh

# Install load balancer
bash scripts/install-metallb.sh
```

### 3. Deploy Applications

```bash
# Deploy sample applications
kubectl apply -f apps/

# Check deployment status
kubectl get applications -n argocd
```

## Project Structure

```
infra-git/
├── README.md                 # This file
├── .gitignore
│
├── scripts/
│   ├── install-k3s.sh           # K3s installation
│   ├── install-argocd.sh        # ArgoCD setup
│   ├── install-monitoring.sh    # Prometheus + Grafana
│   ├── install-traefik.sh       # Ingress controller
│   ├── install-metallb.sh       # Load balancer
│   └── common.sh                # Common functions
│
├── apps/
│   ├── application.yaml        # ArgoCD Application
│   ├── appproject.yaml         # AppProject for RBAC
│   └── repository.yaml         # Git repository config
│
├── monitoring/
│   ├── prometheus/
│   │   ├── values.yaml
│   │   └── dashboards/
│   │
│   ├── grafana/
│   │   └── values.yaml
│   │
│   └── loki/
│       └── values.yaml
│
├── ingress/
│   ├── traefik/
│   │   └── values.yaml
│   │
│   └── middlewares.yaml
│
├── storage/
│   ├── storageclass.yaml
│   └── pvc.yaml
│
└── docs/
    ├── INSTALLATION.md
    ├── OPERATIONS.md
    └── TROUBLESHOOTING.md
```

## Shell Scripts

### install-k3s.sh

Installs K3s Kubernetes distribution:

```bash
bash scripts/install-k3s.sh
# Options:
#   --channel stable  (default)
#   --version v1.27.0 (specific version)
```

### install-argocd.sh

Installs ArgoCD for GitOps:

```bash
bash scripts/install-argocd.sh
# Creates:
#   - argocd namespace
#   - ArgoCD deployment
#   - Initial admin credentials
```

### install-monitoring.sh

Installs Prometheus, Grafana, and Loki:

```bash
bash scripts/install-monitoring.sh
# Deploys:
#   - kube-prometheus-stack
#   - Grafana dashboards
#   - Loki for log aggregation
```

### install-traefik.sh

Installs Traefik ingress controller:

```bash
bash scripts/install-traefik.sh
# Configures:
#   - Traefik IngressController
#   - SSL/TLS support
#   - Middleware rules
```

### install-metallb.sh

Installs MetalLB load balancer:

```bash
bash scripts/install-metallb.sh
# Sets up:
#   - Layer 2 load balancing
#   - IP address pool
#   - Service exposure
```

## Configuration

### ArgoCD Configuration

Edit `apps/application.yaml`:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/BODAPATI88/k8s-gitops-demo.git
    targetRevision: HEAD
    path: apps/
  destination:
    server: https://kubernetes.default.svc
    namespace: default
```

### Monitoring Configuration

Edit `monitoring/prometheus/values.yaml`:

```yaml
prometheus:
  prometheusSpec:
    retention: 30d
    storageSpec:
      volumeClaimTemplate:
        spec:
          resources:
            requests:
              storage: 50Gi
```

## Usage

### Deploy Components

```bash
# Install all components at once
bash scripts/install-k3s.sh
bash scripts/install-argocd.sh
bash scripts/install-monitoring.sh
bash scripts/install-traefik.sh
bash scripts/install-metallb.sh

# Or install individually
bash scripts/install-argocd.sh --namespace argocd
```

### Access Services

```bash
# ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443
# https://localhost:8080

# Prometheus
kubectl port-forward svc/prometheus-operated -n monitoring 9090:9090
# http://localhost:9090

# Grafana
kubectl port-forward svc/grafana -n monitoring 3000:80
# http://localhost:3000

# Loki
kubectl port-forward svc/loki -n monitoring 3100:3100
# http://localhost:3100
```

### Monitor Cluster

```bash
# Watch cluster status
watch kubectl get nodes
watch kubectl get pods -A

# Check application sync status
kubectl get applications -n argocd
kubectl describe application my-app -n argocd

# View component logs
kubectl logs -n argocd deployment/argocd-server
kubectl logs -n monitoring deployment/prometheus-operator
```

## Best Practices

### 1. Version Control

```bash
# Always work in feature branches
git checkout -b feature/add-new-monitoring

# Keep scripts idempotent
# Should be safe to run multiple times

# Use meaningful commit messages
git commit -m "chore: upgrade prometheus to v2.44.0"
```

### 2. Security

- Never commit secrets
- Use RBAC for access control
- Enable network policies
- Scan container images

### 3. Monitoring

- Set up alerting rules
- Create Grafana dashboards
- Monitor application metrics
- Log aggregation with Loki

### 4. Backup

```bash
# Backup etcd
sudo k3s etcd-snapshot save --name snapshot-$(date +%Y%m%d)

# Backup ArgoCD
kubectl get secret argocd-secret -n argocd -o yaml > backup.yaml
```

## Troubleshooting

### Components not starting

```bash
# Check pod status
kubectl get pods -A
kubectl describe pod <pod-name> -n <namespace>

# View logs
kubectl logs <pod-name> -n <namespace>

# Check events
kubectl get events -A --sort-by='.lastTimestamp'
```

### Network issues

```bash
# Check service discovery
kubectl get svc -A
kubectl get endpoints -A

# Test DNS
kubectl run -it --rm debug --image=alpine --restart=Never -- nslookup kubernetes.default

# Check network policies
kubectl get networkpolicies -A
```

### Storage issues

```bash
# Check persistent volumes
kubectl get pv
kubectl get pvc -A

# Describe PVC
kubectl describe pvc <pvc-name> -n <namespace>
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License - See [LICENSE](LICENSE) for details.

## Support

For issues and questions:
- Create an issue on GitHub
- Check [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
- Review [INSTALLATION.md](docs/INSTALLATION.md)
