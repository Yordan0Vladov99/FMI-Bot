#!/bin/bash


if [[ ! $# -eq 1 ]];then
       echo "Error. Expected 1 argument. Got $#."
	exit 1
fi

if [[ ! -f $1 ]] && [[ ! -r $1 ]];then
	echo "Error. Argument must be a readable file."
	exit 3
fi

sentences="../text_files/schedule_sentences.txt"
specialty=$(cat "$1" | head -n 1 | cut -d';' -f4)

day=""
day_exercises=""
while read line;do
	temp_day=$( echo "$line" | cut -d';' -f1)
	course=$(echo "$line" | cut -d';' -f4)
	if [[ $temp_day != $day ]];then
	       if [[ $day != "" ]];then
		        full_day=""
			if [[ $temp_day == "пон" ]];then
				full_day="понеделник"
			elif [[ $temp_day == "вто" ]];then
				full_day="вторник"
			elif [[ $temp_day == "сря" ]];then
				full_day="сряда"
			elif [[ $temp_day == "чет" ]];then
				full_day="четвъртък"
			elif [[ $temp_day == "пет" ]];then
				full_day="петък"
			elif [[ $temp_day == "съб" ]];then
				full_day="събота"
			else
				full_day="неделя"
			fi
			answer=""	
			
			if [[ $full_day == "вторник" ]];then
				answer="Във $full_day  $course имат упражнения по $day_exercises"
			else
				answer="В $full_day $course имат упражнения по $day_exercises"
			fi

			questions="Какви упражнения има в $full_day?
			Какви са упражненията в $full_day?"

			while read question;do
				echo -e "$question\nКоя специалност сте?\n$specialty\n$answer\n" >> $sentences
			done< <(echo -e "$questions")

			questions="Какви упражнения имат $course  в $full_day?
			Какви са упражненията на $course в $full_day?"
			
			while read question;do
				echo -e "$question\n$answer\n" >> $sentences
			done< <(echo -e "$questions")
	       fi
	day="$temp_day"
	fi
	exercise_name=$(echo "$line" | cut -d';' -f3)
	exercise_time=$(echo "$line" | cut -d';' -f2)
	day_exercises="$day_exercises $exercise_name от $exercise_time,"	
done< <(cat "$1")

courses=$(cat "$1" | cut -d';' -f3 | cut -d',' -f1 | sort | uniq)
while read course;do
	course_exercises=$(cat "$1" | grep ";$course,")
	

	answer="Упражненията по $course на $specialty се провеждат"

	while read exercise;do
		temp_day=$(echo "$exercise" | cut -d';' -f1)
		        full_day=""
			if [[ $temp_day == "пон" ]];then
				full_day="понеделник"
			elif [[ $temp_day == "вто" ]];then
				full_day="вторник"
			elif [[ $temp_day == "сря" ]];then
				full_day="сряда"
			elif [[ $temp_day == "чет" ]];then
				full_day="четвъртък"
			elif [[ $temp_day == "пет" ]];then
				full_day="петък"
			elif [[ $temp_day == "съб" ]];then
				full_day="събота"
			else
				full_day="неделя"
			fi

		time=$(echo "$exercise" | cut -d';' -f2)
		if [[ $full_day == "вторник" ]];then
			answer="$answer във $full_day от $time,"
		else
			answer="$answer в $full_day от $time,"
		fi
	done< <( echo -e "$course_exercises")
	
	questions="Къде се провеждат упражненията по $course?
	Кога се провеждат упражненията по $course?
	От колко часът се провеждат упраженията по $course?"

	while read question;do
		echo -e "$question\nКоя специалност сте?\n$specialty\n$answer\n" >> $sentences
	done< <( echo -e "$questions")

	questions="Къде се провеждат упражненията по $course на $specialty?
	Кога се провеждат упражненията по $course на $specialty?
	От колко часът се провеждат упраженията по $course на $specialty?"

	while read question;do
		echo -e "$question\n$answer\n" >> $sentences
	done< <( echo -e "$questions")


done< <(echo -e "$courses")
