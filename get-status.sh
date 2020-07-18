#!/bin/bash
# get device status from csv
## v0.0.1 By Jason Regula

clear
VERSION="v0.0.1"
SCRIPT_NAME=${SCRIPT_NAME:-"$(basename $0)"}
FILEPATH="../resources"

# create space for tempfiles
WORKDIR=$(mktemp -d "${TMPDIR:-/tmp/}$(basename $0).XXXXXXXXXXXX")
TEMPFILE1="$WORKDIR/tempfile1.txt"
touch $TEMPFILE1
trap 'rm -rf $WORKDIR' EXIT

LAYER_1_DEVICES_CSV="./resources/layer2test.csv"
LAYER_2_DEVICES_CSV=""
LAYER_3_DEVICES_CSV=""

# Help File:
HELPFILE="\
""
Check status of network devices reading from .csv file
Usage: ./$SCRIPT_NAME [-ACh] \n\
  $SCRIPT_NAME -c <value> #set how many packets to send, (defualt = 1) //WIP \n\
  $SCRIPT_NAME -t <value> #set timeout for ping response, (defualt = 2) //WIP \n\
  $SCRIPT_NAME -h  (this help file) \n\
"

while getopts A:C:h OPT;
do
  case $OPT in
    A ) PRINTER_IP="$OPTARG";;
    C ) COMMUNITY_KEY="$OPTARG" ;;
    h ) clear; echo -e $HELPFILE
    exit 0;;
    * ) echo ""
    echo -e $HELPFILE
    exit 1;;
   esac
done


#read layer1
function readlayer1() {
echo "Name:,IP:,Status:" >> "$TEMPFILE1"
OLDIFS=$IFS
IFS=','
[ ! -f $LAYER_1_DEVICES_CSV ] && { echo "$LAYER_1_DEVICES_CSV file not found"; exit 99; }
sed '1d' $LAYER_1_DEVICES_CSV | while read name ip group layer
do
	ping -c 1 -t 2 $ip > /dev/null
	[[ $? == "0" ]] && Status="Up" || Status="Down"
	printf "$name,$ip,$Status\n" >> "$TEMPFILE1"
done
IFS=$OLDIFS
cat $TEMPFILE1 | column -xts","
}



function HELP() {
  echo "`tput setaf 5`help has arrived! `tput setaf 7`"
  echo "`tput setaf 3`use flags to set custom settings: `tput setaf 7`"
  echo "`tput setaf 6`-h #show this help dialog `tput setaf 7`"
  echo "`tput setaf 6`-c <value> #set how many packets to send, (defualt is 1)`tput setaf 7`"
  echo "`tput setaf 6`-t <value> #set timeout for ping response, (defualt is 2)`tput setaf 7`"
  sleep 2
  exit
}



readlayer1
# open $WORKDIR
# sleep 20
