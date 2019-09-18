#!/bin/bash
VAGRANT_HOST=127.0.0.1
VAGRANT_PORT=`vagrant ssh-config |grep Port |awk 'END { print $2 }'`

echo "{\"func-testing\":{\"hosts\":[\"${VAGRANT_HOST}\"],\"vars\":{\"func_testing\":true,\"ansible_sudo_pass\":\"vagrant\",\"ansible_ssh_pass\":\"vagrant\",\"ansible_ssh_port\":\"${VAGRANT_PORT}\"}}}"
