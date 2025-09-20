Role Name
=========

My Ansible role for installing "Oh My Zsh", some of its plug-ins, and other command line tools. It can also install and configure the "starship" prompt or the "p10k" theme.

Role Variables
--------------

By default, it installs the "starship" prompt.
To install, instead, the "p10k" theme, pass the variable `with_starship: false`.

By default, it also copies the dot files (i.e., `.zshrc` and `.p10k` for "p10k").
To disable that, pass the variable `copy_dot_files: false`.


Notes
-------

before running the playbook, install requirements 
`ansible-galaxy install -r requirements.yml`

To run the playbook on this system first, choose which playbook you want to run:

Options available:
- starship/p10k
  - playbooks/(starship/p10k)/full.yml - Installs environment with (starship/p10k), ohmyzsh, plugins, kubectl, helm, kustomize and nodejs with pnpm
  - playbooks/(starship/p10k)/k8s-docker.yml - Installs environment with (starship/p10k), ohmyzsh, plugins, kubectl, helm, kustomize and without nodejs/pnpm

Simply run: 

```
ansible-playbook playbooks/(starship/p10k)/(full/k8s-docker).yml -i playbooks/inventory -K
```