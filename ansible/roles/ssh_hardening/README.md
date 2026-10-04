# ssh_hardening

Disables root login and password authentication in SSH. Only key-based login remains.

## What it does

- Copies `files/00-hardening.conf` to `/etc/ssh/sshd_config.d/` (root:root, 0644)
- Validates the config with `sshd -t` before replacing it, so a broken file never lands on the host
- Restarts the `ssh` service on change (handler)

Settings:

| Option                         | Value |
| ------------------------------ | ----- |
| `PermitRootLogin`              | `no`  |
| `PasswordAuthentication`       | `no`  |
| `KbdInteractiveAuthentication` | `no`  |

The `00-` prefix is intentional: in `sshd_config.d/` the first value read wins,
so this file must load before e.g. `50-cloud-init.conf`.

## Requirements

- Debian/Ubuntu with OpenSSH that reads `Include /etc/ssh/sshd_config.d/*.conf`
- **A working SSH key for `ansible_user` before running.** Otherwise you will lock yourself out

## Variables

None. Settings are static. If they ever need to differ between hosts: `templates/` + the `template` module.

## Usage

```yaml
- hosts: vms
  become: true
  roles:
    - ssh_hardening
```

## Verification

```bash
sudo sshd -T | grep -Ei 'permitrootlogin|passwordauthentication|kbdinteractive'
```
