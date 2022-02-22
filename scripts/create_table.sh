#!/bin/bash

if [[ $# -gt 2 ]] || [[ $# -eq 0 ]];then
	echo "Script must accept 1 or 2 arguments."
	exit 1
elif [[ ! -f $1 ]];then
	echo "argument must be a file"
	exit 3

elif [[ ! -r $1 ]];then
	echo "argument isn't readable"
	exit 2

fi

exitfile=""
if [[ $# -eq 2 ]];then
	if [[ ! -f $2 ]] || [[ ! -w $2 ]];then
		echo "argument must be a writable file"
		exit 3	
	fi
	exitfile="$2"
else
	exitfile="exams.csv"
fi

specialty=""
course=""
category=""
teachers=""
format=""
date=""
place=""
time=""

table=""

while read line;do
temp_specialty=$(echo "$line" | cut -d';' -f1)

if [[ $temp_specialty == "СПЕЦИАЛНОСТ" ]];then
	continue
fi
if [[ $temp_specialty != "" ]];then
	if [[ $course != "" ]];then
		table="$table$specialty;$course;$category;$teachers;$format;$date;$place;$time\n"
	fi
	specialty="$temp_specialty"
	course=""
	category=""
	teachers=""
	format=""
	date=""
	place=""
	time=""

fi

temp_course=$(echo "$line" | cut -d';' -f2)

if [[ $(echo "$temp_course" | grep "^кат.") != "" ]];then
	category="$temp_course"
elif [[ $temp_course != "" ]];then

	if [[ $course != "" ]];then
		table="$table$specialty;$course;$category;$teachers;$format;$date;$place;$time\n"
	fi
	course="$temp_course"
	category=""
	teachers=""
	format=""
	date=""
	place=""
	time=""

fi

temp_teacher=$(echo "$line" | cut -d';' -f3)

if [[ $temp_teacher != "" ]];then
	if [[ $teachers != "" ]];then
		teachers="$teachers%$temp_teacher"
	else
		teachers="$temp_teacher"
	fi
fi

temp_format=$(echo "$line" | cut -d';' -f4)

if [[ $temp_format != "" ]];then
	format="$temp_format"
fi

exam_type=$(echo "$line" | cut -d';' -f5)
temp_date=$(echo "$line" | cut -d';' -f6)

if [[ $exam_type != "" ]] || [[ $temp_date != "" ]];then
	if [[ $date == "" ]];then
		if [[ $temp_date != "" ]];then
			date="$exam_type $temp_date"
		else
			date="$exam_type"
		fi
	else
		if [[ $temp_date != "" ]];then
			date="$date%$exam_type $temp_date"
		else
			date="$date%$exam_type"
		fi
	
	fi
fi

temp_place=$(echo "$line" | cut -d';' -f7)

if [[ $temp_place != "" ]];then
	if [[ $place == "" ]];then
		place="$temp_place"
	else
		place="$place%$temp_place"
	fi
fi

temp_time=$(echo "$line" | cut -d';' -f8)

if [[ $temp_time != "" ]];then
	if [[ $time == "" ]];then
		time="$temp_time"
	else
		time="$time%$temp_time"
	fi
fi
 

done<$1

echo -e $table >> "$exitfile"

exit 0
