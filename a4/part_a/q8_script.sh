#!/bin/bash

# Usage: 
# ./prt8_script.sh <nmap_output> <message_file>
#
# nmap_output: is a file to parse containing the port numbers for open sockets
# on server at 142.1.44.135.
#
# message_file: is a file to parse containing a line to send to all open ports
# on server at 142.1.44.135.

if [ $# -ne 2 ]; then
    echo "Usage:"; echo "   ./prt2.A_script.sh <nmap_output> <message_file>";
    exit;
fi

nmap_output=$1
message_file=$2
ip_addr=142.1.44.135

header=0

while IFS=' ' read -ra line; do
    if [ "${line[0]}" = "" ]; then
        header=0;
    elif [ "${line[0]}" = "PORT" ]; then
        header=1;
    elif [ $header -eq 1 ]; then
        IFS='/' read -ra port <<< "${line[0]}";
        echo "Response from port: $port";
        netcat $ip_addr $port < $message_file;
        echo; echo " ------------------------------";
        if [ $? -ne 0 ]; then
            echo "Netcat unsuccessful for port: $port"; # Checks if netcat returns with exit code 0
        fi
    fi
done < "$nmap_output"
