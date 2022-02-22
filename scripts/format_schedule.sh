#!/bin/bash


if [[ $# -gt 2 ]] || [[ $# -eq 0 ]];then
	echo "Script must accept 1 or 2 arguments."
	exit 1
elif [[ ! -f $1 ]] || [[ ! -r $1 ]];then
	echo "Error.First argument must be a readable file."
	exit
fi

exitfile=""

if [[ $# -eq 2 ]];then
	if [[ ! -f $2 ]] || [[ ! -w $2 ]];then
		echo "Error. Second argument must be a writable file."
		exit 3
	fi
	exitfile="$2"
else
	exitfile="../tables/schedules.csv"
fi



day=""
course=$(cat $1 | head -n 1 | cut -d';' -f1)
time_slot=$(cat $1 | head -n 3 | tail -n 1)

while read line;do
	temp_day=$(echo $line | cut -d';' -f1)
	if [[ $temp_day != "" ]];then
		day="$temp_day"
	fi
	index=3

	while read timeslot;do
		if [[ $timeslot != "" ]];then
			time=$(echo "$time_slot" | cut -d ';' -f $index)
			echo "$day;$time;$timeslot;$course" >> "$exitfile"
		fi
		
		index=$((index +1))
	done< <(echo "$line" | sed 's/;/\n/g' | tail -n +3)



done< <(cat $1 | gawk -v RS='"' 'NR % 2 == 0 { gsub(/\n/, " ") } { printf("%s%s", $0, RT) }' | tr -d '"' | tail -n +4)
