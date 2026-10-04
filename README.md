# homelab

Scripts and configuration for a single-node Proxmox VE server running on an old ThinkPad.
Used for learning infrastructure tooling and for hosting a few game servers.

## Layout

```
proxmox/scripts/   shell scripts run on the Proxmox host
ansible/           playbook, inventory and roles for the VMs
```

## Proxmox

VMs are linked clones of template `9000` (Debian 13 genericcloud, cloud-init).

```sh
./proxmox/scripts/newvm.sh <id> <name> <ip> <disk_size>
```

Clones the template, sets a static IP (`/24`, gateway `192.168.0.1`), grows the disk
by `<disk_size>`, sets a console password and starts the VM.

ID ranges: `100-199` VMs, `200-299` LXC, `9000+` templates.

## Ansible

Run from inside `ansible/` so that `ansible.cfg` is picked up:

```sh
cd ansible
ansible-playbook site.yml
```

| Role                                              | Purpose                                      |
| ------------------------------------------------- | -------------------------------------------- |
| [`base`](ansible/roles/base/)                     | Full upgrade and baseline packages           |
| [`ssh_hardening`](ansible/roles/ssh_hardening/)   | Key-only SSH, root login disabled            |

Each role has its own README with variables and usage.

## Workflow

Changes are made and committed on a workstation, pushed to GitHub, then pulled on
the Proxmox host. The host never pushes.

Secrets, public IPs and API tokens are kept out of the repository.
