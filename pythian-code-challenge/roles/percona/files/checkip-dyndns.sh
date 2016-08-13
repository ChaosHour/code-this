#! /usr/bin/env sh 
################################################
# Script to output the datetime, with public ip
# Created for the purpose of this code challenge
# Uncomment set to debug this script.
# 07/18/2016
# Created By Kurt Larsen
################################################

#set -xv

NOW=$(date "+%m%d%Y %T")
CMD1=$( curl -s 'http://checkip.dyndns.org' | sed 's/.*Current IP Address: \([0-9\.]*\).*/\1/g')
LOGFILE=/tmp/chekip-dyndns-output-$(date +%F).log

echo "${NOW} | ${CMD1}" >> ${LOGFILE}
