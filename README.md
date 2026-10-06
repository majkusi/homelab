# homelab

![Proxmox VE](https://img.shields.io/badge/Proxmox_VE-E57000?logo=proxmox&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-EE0000?logo=ansible&logoColor=white)
![Debian](https://img.shields.io/badge/Debian_13-A81D33?logo=debian&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?logo=gnubash&logoColor=white)
![Last commit](https://img.shields.io/github/last-commit/majkusi/homelab)
![Open issues](https://img.shields.io/github/issues/majkusi/homelab)
![License](https://img.shields.io/github/license/majkusi/homelab)

Infrastructure for a single-node Proxmox VE server: VM provisioning scripts, cloud-init templates and Ansible roles.

Built to practise the tooling used in day-to-day infrastructure work, and to host a few game servers for friends.

## Stack

- **Hypervisor:** Proxmox VE on a ThinkPad L440 (i5-4300U, 8 GB RAM)
- **Guests:** Debian 13 cloud images, provisioned with cloud-init
- **Provisioning:** Bash scripts around `qm`
- **Configuration:** Ansible (roles, single `site.yml` playbook)
- **Planned:** Terraform, Tailscale, game servers in unprivileged LXC, monitoring

## Repository layout

```
proxmox/scripts/   VM lifecycle scripts, run on the Proxmox host
ansible/           inventory, playbook and roles for the VMs
docs/              operational notes
```

## Usage

One-time setup on the Proxmox host, so the scripts can be run from anywhere (the repo lives in `/root/homelab`):

```sh
ln -s /root/homelab/proxmox/scripts/newvm.sh /root/homelab/proxmox/scripts/delvm.sh /usr/local/bin
```

Create and remove VMs on the Proxmox host:

```sh
newvm.sh <id> <name> <ip> <final_disk_size_in_gb>
delvm.sh <id>
```

Configure the VMs from the workstation:

```sh
cd ansible
ansible-playbook site.yml
```

Each Ansible role documents its variables in its own README:
[`base`](ansible/roles/base/), [`ssh_hardening`](ansible/roles/ssh_hardening/).

## Documentation

- [Known pitfalls](docs/pitfalls.md)

## Roadmap

Planned work is tracked in [GitHub Issues](https://github.com/majkusi/homelab/issues) and on the [project board](https://github.com/users/majkusi/projects/6).

## Security

The management interface and SSH are never exposed to the internet. SSH on the VMs is key-only with root login disabled. Secrets, API tokens and public IP addresses are kept out of the repository.

## License

[MIT](LICENSE)
