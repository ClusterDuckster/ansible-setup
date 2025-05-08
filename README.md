# ansible-setup

Repo for basic configuration of my servers with ansible.

- Can connect to a brand new server with root user and ssh port 22
- Will configure a sudo user and (if set) a custom ssh port
    - still rerunable without changes after that!

Directory structure as proposed in [ansible best practices](https://docs.ansible.com/ansible/2.8/user_guide/playbooks_best_practices.html#directory-layout)

## Installation

1. Install ansible 2.18.2 (I use it on Ubuntu 24.04 -> [official instructions](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible))
    - with `pipx` it's `pipx install --include-deps ansible`
2. Install pip packages
    - if `pipx` is used to install ansible, inject with
        ```
        pipx inject --include-apps ansible ansible-dev-tools ansible-lint jmespath passlib
        ```
    - if regular pip install just same pip as you have installed ansible with
        ```
        pip install ansible-dev-tools
        pip install ansible-lint
        pip install jmespath
        pip install passlib
        ```
3. Install shell utilities
    ```
    sudo apt update
    sudo apt install sshpass
    ```
<!-- 4. Install requirements from ansible-galaxy
    ```
    ansible-galaxy install -r requirements.yml
    ``` -->
5. I expect an inventory in `./.ansible/hosts.yml`, see [ansible-docs](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html) for structure
    - you can copy my example `cp hosts.example.yml ./.ansible/hosts.yml`

6. I expect a password for ansible-vault in `./.ansible/vault-pw`
    - create on with a secure password `echo "my-secure-pw" > ./.ansible/vault-pw`

7. Include gitconfig of repo to your local gitconfig get the vault diff function.

    Set git to use `.githooks` folder as the folder for hooks to have vaults automatically encrypted on `git commit`.
    ```
    git config --local include.path ../.gitconfig
    git config --local core.hooksPath .githooks
    ```

## Prerequisites

1. Make sure the addresses and ssh ports of your servers are filled in in `./.ansible/hosts.yml`

2. Fill out the user details in `./host_vars/<server_name>/vault.yml` <br>
    [Vaults](https://docs.ansible.com/ansible/latest/vault_guide/vault.html) are split up for each host and group.
    You can manually decrypt encrypt them with the following commands.
    ```sh
    # decrypt single
    ansible-vault decrypt ./group_vars/all/vault.yml

    # decrypt all
    find -name "*vault.yml" -exec ansible-vault decrypt "{}" \;
    # encrypt all
    find -name "*vault.yml" -exec ansible-vault encrypt "{}" \;
    ```

## Usage

You can check the changes that will be made, without acutally changing anything:
```sh
ansible-playbook site.yml --check --diff
```

Run the playbook!
```sh
ansible-playbook site.yml
```

You could also limit hosts/groups
```sh
ansible-playbook site.yml --limit=my_servers
```
