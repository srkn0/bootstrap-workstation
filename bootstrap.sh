#!/usr/bin/env bash
#
# bootstrap.sh - one-command workstation setup.
#
# Installs Ansible (if missing), pulls external Galaxy roles, then runs the
# playbook against localhost. Pass any extra args straight through to
# ansible-playbook, e.g.:
#
#   ./bootstrap.sh --tags mise,neovim
#   ./bootstrap.sh --skip-tags docker --check
#
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

ensure_ansible() {
  if command -v ansible-playbook >/dev/null 2>&1; then
    return
  fi
  log "Ansible not found - installing via apt (sudo required)"
  sudo apt-get update -y
  sudo apt-get install -y software-properties-common
  sudo apt-get install -y ansible
}

main() {
  ensure_ansible

  log "Installing Galaxy role dependencies"
  ansible-galaxy install -r requirements.yml

  log "Running playbook (you'll be prompted for your sudo password)"
  exec ansible-playbook site.yml --ask-become-pass "$@"
}

main "$@"
