
set -euo pipefail
IFS=$'\n\t'

trap ctrl_c INT
trap signal_usr1 SIGUSR1
trap signal_usr2 SIGUSR2

function ctrl_c {
    debug "Trapped CTRL-C"
    callback_continue
}

function signal_usr1 {
    debug "received USR1"
    if [ ${status} -eq 0 ]; then
	call_continue
	sleep 30
	debug "resuming"
	call_suspend
    fi
}

function signal_usr2 {
    debug "received USR2"
    call_continue
    sleep 1
}


function call_suspend {
    notify-send -u low -t 1000 "Suspending ${target}"
    debug SUSPEND
    callback_suspend
    status=0
}

function call_continue {
    notify-send -u low -t 1000 "Continue ${target}"
    debug CONTINUE
    callback_continue
    status=1
}

function debug {
    [ ${debug} -eq 1 ] && echo $(date) :: ${target} :: ${status} :: $1
    return 0
}
usage() { echo "Usage: $0 [-d]" 1>&2; exit 1; }

debug=0

while getopts ":d" o; do
    case "${o}" in
        d)
            debug=1
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

echo "####################"
echo "## CONTINUE"
declare -f callback_continue

echo
echo
echo "####################"
echo "## SUSPEND"
declare -f callback_suspend

while read -r line;
do
    prog=$(echo $line | jq '.container.window_properties.class')
    prog=${prog:1:-1}
    change=$(echo $line | jq '.change')
    change=${change:1:-1}

    debug "${change} ${prog}"

    if [ ${change} = "focus" ]; then
	if [ "${prog}" = "${target}" ] && [ ${status} -eq 0 ]; then
	    call_continue
	else
	    if [ ${status} -eq 1 ] && [ "${prog}" != "${target}" ]; then
		call_suspend		
	    fi
	fi
    fi
done < <(i3-msg -t subscribe -m '[ "window" ]')
