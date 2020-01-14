#!/bin/bash


process_candidates() {

    touch report.txt;
    
    echo "--------START OF SESSION----------";

    while IFS= read -r line; do
        filename=$(cut -d ' ' -f2 <<< $line);
        candidate=$(cut -d ' ' -f1 <<< $line);
        echo "$candidate , $filename";
        if [[ "$filename" = "(secret_file.aes256.txt)" ]]; then
            echo "Found a candidate: $candidate";
            echo "Found a candidate: $candidate" >> report.txt;
            openssl enc -d -aes-256-cbc -md sha256 -in secret_file.aes256.txt -pass pass:$candidate >> report.txt;
        fi;
    done < "${1:-/dev/stdin}"




}


~/JtR/run/./openssl2john.py -c 0 -m 2 -a 100 secret_file.aes256.txt > .hashed
~/JtR/run/./john --wordlist=list.txt --format=openssl-enc --rules:All .hashed | process_candidates






