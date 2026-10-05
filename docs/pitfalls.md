# Known pitfalls

Things that bit me once, so they do not bite me twice.

## Proxmox and VMs

- **Rebuilt VM on the same IP**: SSH fails with `REMOTE HOST IDENTIFICATION HAS CHANGED`. Remove the old host key on the workstation with `ssh-keygen -R <ip>`.
- **`Connection refused` right after starting a clone** is expected. Cloud-init is still running (a minute or two, longer with package upgrades enabled).
- **Fresh clones already reject SSH password login**, before `site.yml` runs (`ssh -o PubkeyAuthentication=no debian@<ip>` returns `Permission denied (publickey)` straight away). The source is not confirmed yet, see [#5](https://github.com/majkusi/homelab/issues/5). The `ssh_hardening` role stays so we do not rely on image defaults.
- **VM given the Proxmox host's IP (`192.168.0.200`)**: two devices answer ARP for the same address, so the UI and SSH work intermittently and SSH may warn `REMOTE HOST IDENTIFICATION HAS CHANGED` (you reached the VM). Do **not** run `ssh-keygen -R` for the host. Get a shell on the host (UI shell, or the laptop's local console if the network is unusable), `qm stop` the VM, destroy it, then clear the workstation's ARP cache with `sudo arp -d 192.168.0.200`. `newvm.sh` now refuses IPs that answer ping.
- **Proxmox documentation examples** use the `10.0.10.x` network and old images (`bionic`). Always substitute your own values.
- **The Proxmox installer does not support Wi-Fi.** Install over Ethernet.
- **Chrome on macOS** needs the *Local Network* permission, otherwise the Proxmox UI does not load even though ping works.

## Shell

- `echo` does not interpret `\n` without `-e`. Use `printf`.
- `2>&1` means "stderr to wherever stdout points **right now**", so order matters: `cmd > /dev/null 2>&1` silences both streams, `cmd 2>&1 > /dev/null` does not.
- `$?` is the exit code of the **last** command. A debug `echo $?` between a command and `if [ $? -ne 0 ]` overwrites it with `echo`'s own (always `0`), so the check never fires. Prefer `if ! cmd; then`, or save it first with `rc=$?`.
- In `[[ ]]`, `-gt`/`-eq` evaluate operands as arithmetic, where a leading `0` means octal: `[[ 09000 -ge 9000 ]]` errors out and is false. Validate numeric input with `=~` first.
- Silence a check's output only if its errors are expected. `qm status` on a free ID fails by design, so both streams go to `/dev/null`; for real actions keep stderr visible.

## Ansible

- **Ansible looks for `ansible.cfg` in the current directory**, so always run it from `ansible/`.
- **`roles/` must sit next to the playbook** (or be set with `roles_path` in `ansible.cfg`).
- **Ansible uploads the file from disk.** An unsaved file in the editor means the old version gets deployed. After a change, verify on the machine, not just the green output.
- **An empty list in YAML is `[]`.** A bare key with a colon is `null`.
