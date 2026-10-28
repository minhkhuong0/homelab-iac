My monorepo for my personal fully declarative 5 nodes Kubernetes setup.
# Features
- Declarative infrastructure configuration with OpenTofu and Ansible. (IaC)
- OpenTofu provisions VMs and Ansible installs K3s and bootstraps Argo CD.
- Argo CD deploys the Kubernetes insfrastructure and applications with GitOps.
- A bare metal NixOS host used for: DNS, Bastion, Kubernetes API load balancer.
# Kubernetes Roadmap
- [x] K3s
- [x] Argo CD
- [x] Longhorn
- [x] MetalLB
- [x] KSOPS
- [x] OpenBao (Vault)
- [x] ArgoCD phases
- [x] Cloudnative Postgres
- [x] cert-manager
- [x] Trusted selfsigned CA and Issuer
- [x] Certs from Let's encrypt
- [ ] Monitoring
- [ ] etcd/Longhorn Backup
- [ ] Offsite backup
- [ ] Testing environment
- [ ] HAProxy
