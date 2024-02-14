#!/bin/bash

domain=win10
target=Virt-manager
status=0  #start assumed suspended, so leaves the current status

callback_suspend () {
    sudo virsh suspend ${domain}
}

callback_continue () {
    sudo virsh resume ${domain} || echo "ok"
}

. base.sh
