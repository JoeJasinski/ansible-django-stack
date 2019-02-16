#!/bin/bash
HOSTNAME=$1
PLAYBOOK=$2
EXTRA_VARS_FILE="/extra-vars.yml"  # mount exta vars file here


ansible-playbook -i '${HOSTNAME},' \
    --extra-vars "@/extra-vars.yml" \
    $PLAYBOOK
