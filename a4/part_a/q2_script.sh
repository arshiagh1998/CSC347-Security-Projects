#!/bin/bash

# Usage: 
# ./q2_script.sh <nmap_output> <message_file>
#
# nmap_output: is a file to parse containing the port numbers for open sockets
# on this host machine.
#
# message_file: is a file to parse containing a line to send to all open ports
# on the host machine.

if [ $# -ne 2 ]; then
    echo "Usage:"; echo "   ./q2_script.sh <nmap_output> <message_file>";
    exit;
fi

nmap_output=$1
message_file=$2

header=0

while IFS=' ' read -ra line; do
    if [ "${line[0]}" = "" ]; then
        header=0;
    elif [ "${line[0]}" = "PORT" ]; then
        header=1;
    elif [ $header -eq 1 ]; then
        IFS='/' read -ra port <<< "${line[0]}";
        netcat localhost $port < $message_file;
        if [ $? -ne 0 ]; then
            echo "Netcat unsuccessful for port: $port"; # Checks if netcat returns with exit code 0
        fi
    fi
done < "$nmap_output"



