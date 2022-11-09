#!/bin/bash

while true
do
  date "+%Y-%m-%d %H:%M:%S"
  echo \
  | openssl s_client -connect localhost:30000 2> /dev/null \
  | openssl x509 -noout -subject -dates -serial \
  | egrep "^not|^subject|^serial"
  echo
  sleep 1
done
