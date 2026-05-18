# NixOS Remote Devbox

NixOS + Home Manager configuration for a remote development VM. The current host is `devbox` and the login user is `nbaer`.

## Included

- Nix flakes and Home Manager
- zsh with aliases, autosuggestions, syntax highlighting, zoxide, direnv, and nix-direnv
- zellij auto-start for SSH sessions
- Starship prompt
- Neovim with AstroNvim config under `dotfiles/nvim`
- Docker and Docker Compose
- Rust tooling through `rustup`
- Python/editor tooling for AstroNvim without Mason-managed binaries
- Pi coding agent managed through Home Manager
- Weekly Nix garbage collection and store optimization
- Permissive remote-dev firewall policy

## Layout

```text
.
├── flake.nix
├── flake.lock
├── hardware-configuration.nix
├── hosts/
│   └── devbox/
│       └── configuration.nix
├── users/
│   └── nbaer/
│       └── home.nix
├── home/
│   └── modules/
│       ├── cli.nix
│       ├── devtools.nix
│       ├── git.nix
│       ├── nvim.nix
│       ├── pi.nix
│       ├── starship.nix
│       ├── zellij.nix
│       └── zsh.nix
├── dotfiles/
│   └── nvim/
└── devshells/
    └── rust/
        └── flake.nix
```

## Required Before Deployment

Do these before rebuilding a real machine.

1. Replace the placeholder hardware file:

```text
hardware-configuration.nix
```

Generate it on the target:

```bash
sudo nixos-generate-config --root /
```

Then copy the generated `/etc/nixos/hardware-configuration.nix` into this repo path. The committed file is only a placeholder so `nix flake check` can evaluate locally.

2. Confirm boot loader and disk layout.

The placeholder hardware config includes a dummy root filesystem. Replace it with the generated target values or a deliberate disk module before installing.

3. Add SSH keys.

Edit [hosts/devbox/configuration.nix](hosts/devbox/configuration.nix):

```nix
openssh.authorizedKeys.keys = [
  "ssh-ed25519 AAAA... your-key-comment"
];
```

Password SSH login is disabled. Without a key, you can lock yourself out.

4. Confirm username and hostname.

- Username is set in [flake.nix](flake.nix): `username = "nbaer";`
- Hostname is set in [hosts/devbox/configuration.nix](hosts/devbox/configuration.nix): `networking.hostName = "devbox";`

5. Keep secrets out of this repo.

Do not commit API keys, SSH private keys, Pi auth files, cloud credentials, or provider tokens. Use runtime environment variables, `sops-nix`, `agenix`, or private files outside the repo.

## Validate Locally

```bash
nix flake check
nix build .#nixosConfigurations.devbox.config.system.build.toplevel --dry-run
```

The current config has been checked with both commands.

## Install On An Existing NixOS Machine

Clone or copy this repo to the target, commonly `/etc/nixos`:

```bash
sudo git clone <repo-url> /etc/nixos
cd /etc/nixos
```

Generate hardware config:

```bash
sudo nixos-generate-config --root /
```

Then switch:

```bash
sudo nixos-rebuild switch --flake /etc/nixos#devbox
```

## Proxmox Deployment

There are three practical paths. Pick based on how automated you want the first install to be.

### Option A: Manual NixOS ISO

This is the simplest and least magical path.

1. Create a Proxmox VM.
2. Attach the NixOS minimal ISO.
3. Boot the VM.
4. Partition and mount disks.
5. Clone this repo into `/mnt/etc/nixos`.
6. Generate hardware config.
7. Run `nixos-install --flake /mnt/etc/nixos#devbox`.

Example partitioning for a UEFI VM with disk `/dev/vda`:

```bash
parted /dev/vda -- mklabel gpt
parted /dev/vda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/vda -- set 1 esp on
parted /dev/vda -- mkpart primary ext4 512MiB 100%

mkfs.fat -F 32 -n boot /dev/vda1
mkfs.ext4 -L nixos /dev/vda2

mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
```

Then:

```bash
mkdir -p /mnt/etc
git clone <repo-url> /mnt/etc/nixos
nixos-generate-config --root /mnt
nixos-install --flake /mnt/etc/nixos#devbox
reboot
```

### Option B: Cloud-Init Bootstrap

Cloud-init is useful for Proxmox, but by itself it is not a full NixOS installer. It can set hostname, SSH keys, networking, and run bootstrap commands. It is best when starting from a NixOS cloud image or a generic Linux image that then hands off to Nix.

In Proxmox, cloud-init can provide:

- username and SSH keys
- static IP or DHCP networking
- packages/scripts for bootstrap
- a one-shot command to clone this repo and run `nixos-rebuild`

This works well if the VM image is already NixOS. It is awkward if cloud-init must also partition a blank disk and install NixOS from scratch.

Minimal cloud-init user-data shape:

```yaml
#cloud-config
hostname: devbox
users:
  - name: nbaer
    groups: wheel
    shell: /run/current-system/sw/bin/zsh
    ssh_authorized_keys:
      - ssh-ed25519 AAAA... your-key-comment
runcmd:
  - git clone <repo-url> /etc/nixos
  - nixos-rebuild switch --flake /etc/nixos#devbox
```

Use this only after the base image has Nix, flakes, git, and working `/etc/nixos` expectations. For fresh blank disks, prefer Option A or Option C.

### Option C: Fully Automated With disko

For repeatable VM installation, add `disko`. Disko can declaratively partition and format disks, then NixOS can install using the same flake.

This repo does not yet include disko. A future layout would look like:

```text
hosts/devbox/
├── configuration.nix
└── disko.nix
```

Then `flake.nix` would include the `disko` input and import the disk module for `devbox`.

The install flow becomes:

```bash
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
  --mode disko ./hosts/devbox/disko.nix

sudo nixos-install --flake .#devbox
```

This is the cleanest way to bootstrap partitioning during install. Cloud-init can still be used at the Proxmox layer to launch the installer, but disko should own the partitioning details.

## Home Manager Modules

### Devtools

Edit [home/modules/devtools.nix](home/modules/devtools.nix) for user-level development tools.

Current editor/Python tooling is installed with Nix rather than Mason:

- `lua-language-server`
- `stylua`
- `basedpyright`
- `ruff`
- `black`
- `isort`
- `python3Packages.debugpy`
- `ty`
- `nixd`
- `nixfmt`
- `tree-sitter`
- `nodejs`

This keeps AstroNvim integrations stable on NixOS.

### Neovim

Home Manager enables Neovim in [home/modules/nvim.nix](home/modules/nvim.nix) and links:

```text
dotfiles/nvim -> ~/.config/nvim
```

AstroNvim plugins are managed by lazy.nvim. First launch needs network access to fetch plugins. Mason automatic installation is disabled in:

```text
dotfiles/nvim/lua/plugins/mason.lua
```

### Pi Coding Agent

Pi is configured in [home/modules/pi.nix](home/modules/pi.nix).

It installs:

```nix
pkgs.pi-coding-agent
```

It manages:

```text
~/.pi/agent/settings.json
~/.pi/agent/AGENTS.md
```

Auth is not stored in this repo. After deployment:

```bash
pi
/login
```

or provide provider API keys through environment variables.

Pi is currently available from `nixos-unstable`. This repo already uses and locks `nixos-unstable`, so that is fine. If the host later moves to stable, add a separate unstable input and install only `unstablePkgs.pi-coding-agent`.

### zsh and zellij

zsh configuration lives in [home/modules/zsh.nix](home/modules/zsh.nix). It auto-starts zellij for SSH sessions:

```zsh
if [[ -z "$ZELLIJ" && -n "$SSH_CONNECTION" ]]; then
  zellij attach main -c
fi
```

Remove that block if you prefer a plain shell on login.

## Firewall

The firewall is intentionally permissive for remote development:

- TCP `22`, `80`, `443`
- TCP range `1024-65535`
- UDP range `60000-61000` for Mosh

Tighten this in [hosts/devbox/configuration.nix](hosts/devbox/configuration.nix) if the VM is exposed directly to the internet.

## Updating

Update pinned inputs:

```bash
nix flake update
nix flake check
```

Then rebuild:

```bash
sudo nixos-rebuild switch --flake .#devbox
```

## Remaining Setup Checklist

- Replace placeholder hardware config with target-generated config.
- Add real SSH public keys.
- Confirm disk device and boot loader settings.
- Decide whether to add disko for repeatable Proxmox partitioning.
- Run Pi `/login` or provide provider API keys.
- Launch Neovim once with network so lazy.nvim can fetch AstroNvim plugins.
- Consider `sops-nix` or `agenix` before adding any secrets.
