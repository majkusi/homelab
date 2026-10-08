# base

Baseline configuration for every VM: full system upgrade and installation of basic packages.

## What it does

- `apt update` + `upgrade: dist`
- Installs `base_packages` + `base_packages_extra`

## Requirements

- Debian/Ubuntu (`apt` module)
- `become: true` in the playbook

## Variables

| Variable                     | Default             | Description                                           |
| ---------------------------- | ------------------- | ----------------------------------------------------- |
| `base_packages`              | `[git, htop, curl]` | Packages for every host. Overriding replaces the list |
| `base_packages_extra`        | `[]`                | Extra packages per group/host (`group_vars`)          |
| `base_update_check_interval` | `3600`              | Sets maximum age of the apt cache in seconds          |

Groups **add** packages via `base_packages_extra` instead of overriding `base_packages`.

## Usage

```yaml
- hosts: vms
  become: true
  roles:
    - base
```

`group_vars/vms.yml`:

```yaml
base_packages_extra:
  - tree
```
