# BVR Infra Platform Inventory

## Virtualization Layer

| Component | Details |
|---|---|
| Hypervisor | Proxmox |
| Host | Laptop1 |
| CPU | i5 5th Gen |
| RAM | 8GB |
| Storage | 1TB SSD + 2TB External HDD |

---

## Kubernetes Cluster

| Node | IP | Role |
|---|---|---|
| k8s-master | 192.168.29.100 | Control Plane |
| k8s-worker1 | 192.168.29.101 | Worker |
| platform-ui | VM | Frontend/UI |

---

## Core Services

| Service | Location | Port | Purpose |
|---|---|---|---|
| Prometheus | Kubernetes | 9090 | Metrics |
| Grafana | Kubernetes | 3000 | Dashboards |
| ArgoCD | Kubernetes | 8080 | GitOps |
| metrics-api | Kubernetes | 8000 | Telemetry API |
| platform-ui | nginx VM | 80 | Frontend |

---

## Public Endpoints

| Endpoint | Purpose |
|---|---|
| https://platform.bvrinfra.in | Platform UI |
| https://api.bvrinfra.in | Metrics API |

---

## Edge Layer

| Component | Details |
|---|---|
| Cloudflare Tunnel | Enabled |
| SSL | Cloudflare Proxy |
