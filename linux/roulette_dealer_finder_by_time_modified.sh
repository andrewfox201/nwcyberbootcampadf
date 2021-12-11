#!/bin/bash

cat $1_Dealer_schedule | grep $2 | awk -F " " '{print $1,$2,$5,$6}'


#3arguements
#$1 is the four digits of the date name in front of schedule i.e. 0310
#$2 is the time i.e. 07:00
#$3is AM or PM i.e. AM

