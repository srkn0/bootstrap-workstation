# Quick, throwaway end-to-end check of the Linux path:
#   docker build -f tests/Dockerfile -t bootstrap-workstation:test .
# (Docker daemon, Homebrew and the WSL/Windows steps are disabled - they need
# systemd / a Windows host that a plain build container doesn't have.)
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      python3 python3-pip sudo ansible git curl ca-certificates locales \
 && locale-gen en_US.UTF-8 \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash dev \
 && echo "dev ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dev

USER dev
WORKDIR /home/dev/bootstrap-workstation
COPY --chown=dev:dev . .

RUN ansible-galaxy install -r requirements.yml \
 && ansible-playbook site.yml -i inventory \
      -e with_docker=false \
      -e with_brew=false \
      -e is_wsl=false \
      -e nvim_sync=false

CMD ["/bin/zsh"]
