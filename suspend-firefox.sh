#!/bin/bash

target=firefox
processname=/usr/lib/firefox/firefox
status=0  #start assumed suspended, so leaves the current status

callback_continue () {
    killall -s CONT ${processname}
}

callback_suspend () {
    killall -s STOP ${processname}
}

. base.sh
