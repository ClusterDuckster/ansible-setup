#!/bin/sh
# Making sure any decrypted vault file can be viewed without an error
ansible_vault_header=$(sed -n '/^$ANSIBLE_VAULT/p;q' "$1")
if [ ! "$ansible_vault_header" ];then
    cat $1
else
    ansible-vault view $1
fi
