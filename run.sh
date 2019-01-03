#!/bin/bash

[ -z "$1" ] && echo "Error: No target argument given" && exit 1;

if [ "$USE_KEY" != "0" ] && [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
    echo -e "\n\nPlease copy public key to the servers authorized_keys file before continuing:\n"
    cat ~/.ssh/id_rsa.pub
    echo -e "\n"
    read -p "Press [Enter] to contiue..."
fi

sshHost=$(awk -F@ '{print $2}' <<<$1)

ssh -p $SSH_PORT $1 "killall vboxwebsrv"
ssh -p $SSH_PORT -L 0.0.0.0:18083:$sshHost:$PORT $1 "killall vboxwebsrv; vboxwebsrv -p $PORT -A null -H $sshHost"
