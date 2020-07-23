#!/bin/bash
# list device status from csv
## v0.0.3 By Jason Regula

clear
VERSION="v0.0.3"
SCRIPT_NAME=${SCRIPT_NAME:-"$(basename $0)"}
FILEPATH="./resources/"
[[ -d $FILEPATH ]] || mkdir $FILEPATH

echo "$SCRIPT_NAME Version: $VERSION by Jason Regula"
echo ""

# create space for tempfiles
WORKDIR=$(mktemp -d "${TMPDIR:-/tmp/}$(basename $0).XXXXXXXXXXXX")
TEMPFILE1="$WORKDIR/tempfile1.txt"
TEMPFILE2="$WORKDIR/tempfile2.txt"
TEMPFILE3="$WORKDIR/tempfile3.txt"
TEMPSORTFILE1="$WORKDIR/tempsortfile1.txt"
TEMPSORTFILE2="$WORKDIR/tempsortfile2.txt"
TEMPFINALFILE="$WORKDIR/tempfinalfile.txt"
touch $TEMPFILE1
touch $TEMPFILE2
touch $TEMPFILE3
touch $TEMPSORTFILE1
touch $TEMPSORTFILE2
trap 'rm -rf $WORKDIR' EXIT

#files locations
DEVICE_LIST_1_CSV="$FILEPATH/switches.csv"
DEVICE_LIST_2_CSV="$FILEPATH/accesspoints.csv"
DEVICE_LIST_3_CSV="$FILEPATH/ip-list.csv"

#set defualt values
PING_COUNT="1"
PING_TIMEOUT="2"

# Help File:
HELPFILE="\
""
$SCRIPT_NAME Version: $VERSION by Jason Regula \n\
Get status of network devices in a formatted hiracial list, reading from a .csv file. \n\
File should be formatted by column as follows: A=Name,B=IP,C=Group,D=Layer \n\
\n\
Usage: ./$SCRIPT_NAME [-ctfh] \n\
  $SCRIPT_NAME -c <value> #set how many packets to ping with, (defualt = 1)\n\
  $SCRIPT_NAME -t <value> #set timeout for ping response, (defualt = 2)\n\
  $SCRIPT_NAME -f <file_path> #read from specified csv file with ip's in column 'B' (ignores row 1) \n\
  $SCRIPT_NAME -h  (this help file) \n\
"


#color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m' #No Color


#read csv 1
function readlist1() {
echo "Name:,IP:,ping_status:" >> "$TEMPFILE1"
OLDIFS=$IFS
IFS=','
[ ! -f $DEVICE_LIST_1_CSV ] && { echo "$DEVICE_LIST_1_CSV file not found"; exit 99; }
sed '1d' $DEVICE_LIST_1_CSV | while read name ip group layer
do
	ping -c $PING_COUNT -t $PING_TIMEOUT $ip > /dev/null
	[[ $? == "0" ]] && ping_status="Up" || ping_status="Down"
	printf "$name,$ip,$ping_status\n" >> "$TEMPFILE1"
  printf "$name,$ip,$ping_status,$group,$layer\n" >> "$TEMPSORTFILE1"
done
IFS=$OLDIFS
#debug
# cat $TEMPFILE1 | column -xts","
}

#read csv 2
function readlist2() {
echo "Name:,IP:,ping_status:" >> "$TEMPFILE2"
OLDIFS=$IFS
IFS=','
[ ! -f $DEVICE_LIST_2_CSV ] && { echo "$DEVICE_LIST_2_CSV file not found"; exit 99; }
sed '1d' $DEVICE_LIST_2_CSV | while read name ip group layer
do
	ping -c $PING_COUNT -t $PING_TIMEOUT $ip > /dev/null
	[[ $? == "0" ]] && ping_status="Up" || ping_status="Down"
	printf "$name,$ip,$ping_status\n" >> "$TEMPFILE2"
  printf "$name,$ip,$ping_status,$group,$layer\n" >> "$TEMPSORTFILE1"
done
IFS=$OLDIFS
#debug
# cat $TEMPFILE2 | column -xts","
}

#read csv 3
function readlist3() {
echo "Name:,IP:,ping_status:" >> "$TEMPFILE3"
OLDIFS=$IFS
IFS=','
[ ! -f $DEVICE_LIST_3_CSV ] && { echo "$DEVICE_LIST_3_CSV file not found"; exit 99; }
sed '1d' $DEVICE_LIST_3_CSV | while read name ip group layer
do
	ping -c $PING_COUNT -t $PING_TIMEOUT $ip > /dev/null
	[[ $? == "0" ]] && ping_status="Up" || ping_status="Down"
	printf "$name,$ip,$ping_status\n" >> "$TEMPFILE3"
  printf "$name,$ip,$ping_status,$group,$layer\n" >> "$TEMPSORTFILE1"
done
IFS=$OLDIFS
#debug
# cat $TEMPFILE3 | column -xts","
}


#sort file
function sortlist() {
OLDIFS=$IFS
IFS=','
[ ! -f $TEMPSORTFILE1 ] && { echo "$TEMPSORTFILE1 file not found"; exit 99; }
sort -b -k 4,5 -t , $TEMPSORTFILE1 | while read name ip ping_status group layer
do
  if [[ "$layer" = *"0"* ]]; then
      printf "═╦╦╦╦╦╦,$name,$ip,$ping_status\n" >> "$TEMPSORTFILE2"
  elif [[ "$layer" = *"1"* ]]; then
      printf " ╠╦╦╦╦╦,$name,$ip,$ping_status\n" >> "$TEMPSORTFILE2"
  elif [[ "$layer" = *"2"* ]]; then
      printf " ║╠╦╦╦╦,$name,$ip,$ping_status\n" >> "$TEMPSORTFILE2"
  elif [[ "$layer" = *"3"* ]]; then
      printf " ║║╠╦╦╦,$name,$ip,$ping_status\n" >> "$TEMPSORTFILE2"
  elif [[ "$layer" = *"4"* ]]; then
      printf " ║║║╠╦╦,$name,$ip,$ping_status\n" >> "$TEMPSORTFILE2"
  elif [[ "$layer" = *"5"* ]]; then
      printf " ║║║║╠╦╦,$name,$ip,$ping_status\n" >> "$TEMPSORTFILE2"
  elif [[ "$layer" = *"?"* ]]; then
      printf " ║║║║║║?,$name,$ip,$ping_status,Unknown Layer,\n" >> "$TEMPSORTFILE2"
  else
      printf " ║??????,$name,$ip,$ping_status,Other Error\n" >> "$TEMPSORTFILE2"
  fi
done
IFS=$OLDIFS
#debug
# cat $TEMPSORTFILE2 | column -xts","
}


#format output
function format() {
printf "Topo:,Name:,IP:,Status:\n" >> "$TEMPFINALFILE"
OLDIFS=$IFS
IFS=','
[ ! -f $TEMPSORTFILE2 ] && { echo "$TEMPSORTFILE2 file not found"; exit 99; }
cat $TEMPSORTFILE2 | while read topo name ip ping_status group layer
do
  #catch header to prevent else from formatting it
	if [[ "$topo" == "Topo:" ]]; then
	printf "$topo,$name,$ip,$ping_status,$group,$layer\n" >> $TEMPFINALFILE
elif [[ "$ping_status" == "Up" ]]; then
	printf "$topo,$name,$ip,${GREEN}$ping_status${NC},$group,$layer\n" >> $TEMPFINALFILE
elif [[ "$ping_status" == "Down" ]]; then
  printf "$topo,$name,$ip,${RED}$ping_status${NC},$group,$layer\n" >> $TEMPFINALFILE
else #formatting for errors
  printf "$topo,$name,$ip,${ORANGE}script/file error${NC},$group,$layer\n" >> $TEMPFINALFILE
fi
done
IFS=$OLDIFS
#debug
# cat $TEMPFINALFILE | column -xts","
}

#check for flags
while getopts t:c:f:h OPT;
do
  case $OPT in
    c ) PING_COUNT="$OPTARG";;
    t ) PING_TIMEOUT="$OPTARG" ;;
    f ) DEVICE_LIST_1_CSV="$OPTARG"
    readlist1
    sortlist
    format
    cat $TEMPFINALFILE | column -xts","
    exit 0;;
    h ) clear; echo -e $HELPFILE
    exit 0;;
    * ) echo ""
    echo -e $HELPFILE
    exit 1;;
   esac
done


#defualt run commands
[[ -f $DEVICE_LIST_1_CSV ]] && readlist1
[[ -f $DEVICE_LIST_2_CSV ]] && readlist2
[[ -f $DEVICE_LIST_3_CSV ]] && readlist3
sortlist
format
cat $TEMPFINALFILE | column -xts","
#debug
# open $WORKDIR
# sleep 20
