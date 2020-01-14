#!/bin/bash

~/JtR/run/./rar2john secret_song.rar > rarhash # get the rar hash and store in rarhash

list_dir=$1
rar_rule=$2

for list in "$list_dir"/*; do
    echo "-------Starting list: $list"; echo; echo;
    ~/JtR/run/./john --wordlist=$list --rules:$2 --fork=2 rarhash;
    echo; echo; echo "-------Done list: $list"; echo; echo;
done