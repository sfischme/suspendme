#!/bin/bash

target=Chromium
processname=chromium
status=0  #start assumed suspended, so leaves the current status

callback_continue () {
    killall -s CONT ${processname}
}

callback_suspend () {
    killall -s STOP ${processname}
}

. base.sh
