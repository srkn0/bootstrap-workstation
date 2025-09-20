Role Name
=========

My Ansible role for installing "Oh My Zsh", some of its plug-ins, and other command line tools. It can also install and configure the "starship" prompt or the "p10k" theme.

Role Variables
--------------

By default, it installs the "starship" prompt.
To install, instead, the "p10k" theme, pass the variable `with_starship: false`.

By default, it also copies the dot files (i.e., `.zshrc` and `.p10k` for "p10k").
To disable that, pass the variable `copy_dot_files: false`.

Example Playbook
----------------

For `starship` (default):

```yaml
    - name: Install Oh My Zsh
      ansible.builtin.include_role:
        name: srkn0.oh_my_zsh
```

For `p10k`:

```yaml
    - name: Install Oh My Zsh
      ansible.builtin.include_role:
        name: srkn0.oh_my_zsh
      vars:
        with_starship: false
        copy_dot_files: false
```

Notes
-------

before running the playbook, install requirements 
`ansible-galaxy install -r requirements.yml`

To run the playbook on this system for `starship` (default):

```
ansible-playbook playbooks/bootstrap.yml -i playbooks/inventory -K
```

To run the playbook on this system for `p10k`:

```
ansible-playbook playbooks/bootstrap.yml -i playbooks/inventory -K --extra-vars '{"with_starship":false}'
```
