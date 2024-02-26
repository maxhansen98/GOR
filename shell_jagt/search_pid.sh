#!/usr/bin/env bash

# get all args
while getopts ':h:u:p:o:' opt; do
  case $opt in
    h) HOPT=$OPTARG ;;
    u) UOPT=$OPTARG ;;
    p) POPT=$OPTARG ;;
    o) OOPT=$OPTARG ;;
  esac
done

hosts=$HOPT
usr=$UOPT
process=$POPT
out=$OOPT

# this is a hard coded path of my isrunning_script
# othherwise i would'ha had to somehow execute this local script on the ssh connection
isrunning_script="~/local_scripts/isrunning.sh"


# main loop iterating over host names in $hosts
while IFS= read -r host; do
    echo "$host"
    client_out=$(ssh -n -i ~/.ssh/cip -o ConnectTimeout=10 weyrichm@"$host.cip.ifi.lmu.de" "bash $isrunning_script $POPT $UOPT")
    # client_out=$(ssh -n -i ~/.ssh/cip -o ConnectTimeout=10 weyrichm@"$host.cip.ifi.lmu.de" "bash $isrunning_script ppurld berchtolde")

    # capture exit status of ssh command
    ssh_exit_status=$?

    if [[ $ssh_exit_status == 1 ]]; then
        echo "Running in: "$host
    fi
done < "$hosts"
