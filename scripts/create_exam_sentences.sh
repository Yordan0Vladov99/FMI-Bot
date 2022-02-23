#!/bin/bash


if [[ ! $# -eq 1 ]];then
       echo "Error. Expected 1 argument. Got $#."
	exit 1
fi

if [[ ! -f $1 ]] && [[ ! -r $1 ]];then
	echo "Error. Argument must be a readable file."
	exit 3
fi


sentences="../text_files/exam_sentences.txt"

while read line;do
	dates=$(echo "$line" | cut -d';' -f6 | sed 's/%/\n/g')
	places=$(echo "$line" | cut -d';' -f7 | sed 's/%/\n/g')
	hours=$(echo "$line" | cut -d';' -f8 | sed 's/%/\n/g')
	
	formated_str=$(echo -e "$dates\n$places\n$hours" | awk '{array[NR] = $0}END{
	for(x=1;x<=NR/3;x++){
		print array[x]";"array[x+NR/3]";"array[x+2*NR/3]
	}
}')
	specialty=$(echo "$line" | cut -d';' -f1)
	course=$(echo "$line" | cut -d';' -f2)
	category=$(echo "$line" | cut -d';' -f3)
	teachers=$(echo "$line" | cut -d';' -f4 | sed 's/%/,/g')
	format=$(echo "$line" | cut -d';' -f5)
	sentence="Изпит по $course на $specialty ще се проведе"
	while read string;do
		date=$(echo $string | cut -d';' -f1)
		place=$(echo $string | cut -d';' -f2)
		time=$(echo $string | cut -d';' -f3)

		if [[ $place == "" ]] && [[ $time == "" ]];then
			sentence="$sentence $date,"
		else
			sentence="$sentence на $date в $place от $time,"
		fi
	done< <(echo -e "$formated_str")

	sentence=$(echo "$sentence" | sed 's/,$/\./g')
#	questions="На коя дата ще се провежда изпитът по $course на $specialty?
#В коя зала ще се провежда изпитът по $course на $specialty?
#От колко часът ще се провежда изпитът по $course на $specialty?
#Къде от ще се провежда изпитът по $course  на $specialty?
#Кога ще се провежда изпитът по $course на $specialty?
#В коя зала ще се провежда изпитът по $course на $specialty?
#От кога изпитът по $course на $specialty?
#Къде е изпитът по $course на $specialty?"

questions="На коя дата ще се провежда изпитът по $course
В коя зала ще се провежда изпитът по $course
От колко часът ще се провежда изпитът по $course
Къде от ще се провежда изпитът по $course
Кога ще се провежда изпитът по $course
В коя зала ще се провежда изпитът по $course
От кога изпитът по $course
Къде е изпитът по $course"


	while read question;do
		echo -e "$question на $specialty?\n$sentence\n" >> "$sentences"
		echo -e "$question?\nКоя специялност сте?$specialty\n$sentence\n"
	done< <(echo -e "$questions")

	sentence="Курсът $course на $specialty се преподава от $teachers."
	questions="Кой преподава по $course
	Кой е учителският състав по $course"
	
	while read question;do
		echo -e "$question на $specialty\n$sentence\n" >> "$sentences"
		echo -e "$question?\nКоя специалност сте?\n$specialty\n$sentence\n" >> "$sentences"
	done< <(echo -e "$questions")
	
	sentence="Курсът $course на $specialty попада в $category."

	questions="Какъв е $course
	Към каква категория приспада $course"
	
	while read question;do
		echo -e "$question на $specialty?\n$sentence\n" >> "$sentences"
		echo -e "$question?\nКоя специалност сте?\n$specialty\n$sentence\n" >> "$sentences"
	done< <(echo -e "$questions")

	sentence="Изпитът по $course на $specialty ще се проведе $format."
	questions="Изпитът по $course на $specialty присъствен ли ще е?
	Изпитът по $course на $specialty електронен ли ще е?
	Изпитът по $course на $specialty присътвен ли е?
	Изпитът по $course на $specialty електронене ли е?
	Как ще се проведе изпитът по $course на $specialty?"
	
	while read question;do
		echo -e "$question\n$sentence\n" >> "$sentences"
	done< <(echo -e "$questions")
	
	questions="Изпитът по $course присъствен ли ще е?
	Изпитът по $course електронен ли ще е?
	Изпитът по $course присътвен ли е?
	Изпитът по $course електронене ли е?
	Как ще се проведе изпитът по $course?"
	
	while read question;do
		echo -e "$question\nКоя специалност сте?\n$specialty\n$sentence\n" >> "$sentences"
	done< <(echo -e "$questions")

done< <(cat $1 | grep -v '^[[:space:]]*$')
