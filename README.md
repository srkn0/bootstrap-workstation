# bootstrap-workstation

[![CI](https://github.com/srkn0/bootstrap-workstation/actions/workflows/ci.yml/badge.svg)](https://github.com/srkn0/bootstrap-workstation/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

One command to turn a fresh **Ubuntu / Debian / WSL2** box into my full development
workstation: zsh + [Starship](https://starship.rs), [Neovim](https://neovim.io)
(LazyVim), all my CLI tooling and language runtimes via [mise](https://mise.jdx.dev),
Docker, Homebrew — and, on WSL, the Nerd Font installed on the **Windows** host with
Windows Terminal wired up to use it.

```bash
git clone https://github.com/srkn0/bootstrap-workstation.git
cd bootstrap-workstation
./bootstrap.sh
```

## Design: two layers

The repo is deliberately split so each tool is owned by exactly one thing:

| Layer | Owns | How |
|-------|------|-----|
| **Ansible** (`roles/workstation`) | the OS layer that needs root or can't be a user binary | apt packages, zsh + Oh My Zsh, fonts, the Docker daemon, installing mise, deploying every dotfile, and the WSL→Windows integration |
| **mise** (`files/mise/config.toml`) | every CLI tool + language runtime | one committed, version-pinned `~/.config/mise/config.toml`; `mise install` does the rest |
| **Homebrew** | ad-hoc one-offs not worth pinning | `brew install …` whenever |

Why mise for the tools? It's declarative, version-pinned, reproducible, and the same
`mise.toml` mechanism already used per-project. Adding/removing a tool is a one-line diff
instead of a bespoke Ansible task — which is also why this repo *deleted* a pile of
brittle custom installers.

```
roles/workstation/
├── tasks/        facts · packages · shell · brew · mise · fonts · windows · neovim · starship · dotfiles · docker
├── files/        mise/config.toml · nvim/ (LazyVim) · starship/ · tmux/ · atuin/
├── templates/    zshrc.j2  (mise/brew/WSL conditionals)
├── defaults/     feature toggles + Nerd Font vars
└── vars/         docker.yml
site.yml · inventory · bootstrap.sh · Makefile · requirements.yml
molecule/ · tests/Dockerfile · .github/workflows/ci.yml
```

## What you get

- **Shell** — zsh, Oh My Zsh (+ autosuggestions, syntax-highlighting, completions,
  autoupdate), Starship prompt, atuin history, zoxide, fzf.
- **Editor** — Neovim with my actual LazyVim config (Go + JSON language extras), vendored
  verbatim so a fresh box gets the identical editor.
- **Languages** — Go, Node (LTS) **+ pnpm**, Python — all via mise; plus `golangci-lint`.
- **Modern CLI** — eza, bat, fd, ripgrep, fzf, broot, lazygit, gh, direnv, tmux.
- **Kubernetes / IaC** — kubectl, kind, helm, kustomize, k9s, kubectx/kubens, terraform.
- **Containers** — Docker engine (via `geerlingguy.docker`).
- **Terminal & font** — Agave Nerd Font (swap via `nerd_font`) installed and wired into
  the terminal on both OSes: kitty on native Linux, Windows Terminal on WSL.

## Terminal & font, per OS

The role detects WSL at runtime (`is_wsl`) and wires the Nerd Font into the right place:

**Native Linux** — installs the font into `~/.local/share/fonts`, installs **kitty**, and
deploys `~/.config/kitty/kitty.conf` set to the Nerd Font. (`with_kitty`, default on.)

**WSL2** — kitty is skipped; instead:

1. Installs the Nerd Font onto the **Windows** host per-user (no admin) — copies the
   `.ttf`s into `%LOCALAPPDATA%\Microsoft\Windows\Fonts` and registers them under `HKCU`.
2. **Patches** the live Windows Terminal `settings.json` in place — sets only
   `profiles.defaults.font` (face + size; timestamped backup, idempotent). Your profiles,
   keybindings, default profile and theme are left untouched.

The font name (`nerd_font` / `nerd_font_face`) and `terminal_font_size` are shared by both
paths, so changing the font is a one-line edit that applies everywhere.

## Usage

```bash
./bootstrap.sh                       # everything (prompts for sudo)
ansible-playbook site.yml -K --tags mise,neovim    # just some parts
ansible-playbook site.yml -K --skip-tags docker    # everything except Docker
make check                           # dry run (--check --diff)
```

Toggle features in `roles/workstation/defaults/main.yml` (e.g. `with_docker`,
`with_brew`, `wt_set_font`) or override on the CLI with `-e with_docker=false`.

## Testing

```bash
make lint          # yamllint + ansible-lint
make test          # full Molecule run in a Docker (systemd) Ubuntu container
make test-docker   # quick end-to-end build of the Linux path in a clean Ubuntu image
```

CI runs the lint suite and the Molecule scenario on every push / PR.

## Notes

- `tmux` is the one CLI tool installed via apt rather than mise (it's reliable from the
  distro and avoids a heavy build).
- Tested on Ubuntu 22.04/24.04 and Ubuntu-on-WSL2. macOS support is intentionally out of
  scope for now, but the layering keeps it easy to add.

## License

MIT © srkn0
