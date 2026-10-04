# Known pitfalls

Things that bit me once, so they do not bite me twice.

## Proxmox and VMs

- **Rebuilt VM on the same IP**: SSH fails with `REMOTE HOST IDENTIFICATION HAS CHANGED`. Remove the old host key on the workstation with `ssh-keygen -R <ip>`.
- **`Connection refused` right after starting a clone** is expected. Cloud-init is still running (a minute or two, longer with package upgrades enabled).
- **Fresh clones already reject SSH password login**, before `site.yml` runs (`ssh -o PubkeyAuthentication=no debian@<ip>` returns `Permission denied (publickey)` straight away). The source is not confirmed yet, see [#5](https://github.com/majkusi/homelab/issues/5). The `ssh_hardening` role stays so we do not rely on image defaults.
- **Proxmox documentation examples** use the `10.0.10.x` network and old images (`bionic`). Always substitute your own values.
- **The Proxmox installer does not support Wi-Fi.** Install over Ethernet.
- **Chrome on macOS** needs the *Local Network* permission, otherwise the Proxmox UI does not load even though ping works.

## Shell

- `echo` does not interpret `\n` without `-e`. Use `printf`.
- `2>&1` means "stderr to wherever stdout points **right now**", so order matters: `cmd > /dev/null 2>&1` silences both streams, `cmd 2>&1 > /dev/null` does not.

## Ansible

- **Ansible looks for `ansible.cfg` in the current directory**, so always run it from `ansible/`.
- **`roles/` must sit next to the playbook** (or be set with `roles_path` in `ansible.cfg`).
- **Ansible uploads the file from disk.** An unsaved file in the editor means the old version gets deployed. After a change, verify on the machine, not just the green output.
- **An empty list in YAML is `[]`.** A bare key with a colon is `null`.
