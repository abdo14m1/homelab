# K8s HomeLab

## Hardware

- **Laptop:** Lenovo IdeaPad
- **GPU:** NVIDIA GTX 1650
- **RAM:** 20GB
- **OS:** Ubuntu Server
- **K8s Distribution:** K3s

## Key Components

- **NVIDIA Device Plugin:** Exposes GPU resources to Kubernetes
  
## Current State

The cluster is configured with:
- GPU resources exposed as `nvidia.com/gpu`

## What Works

- GPU workloads can request and use the GTX 1650