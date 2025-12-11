#!/bin/bash

#In this script, I'm going to create a new txt file with the data I will be using for this project.
#Columns currently are 
#YYY/MM/DD HH:mm:SS.ss ET GT MAG  M    LAT       LON      DEPTH Q  EVID      NPH NGRM
#and there are some rows I don't need. 

#First I'm going to remove the rows that I don't need. Then I'm going to extract the
#YYY/MM/DD HH:mm:SS.ss MAG LAT LON  DEPTH --> These are columns  $1 $2 $5 $7 $8 $9

#Variables
Northridge_1_year='Data/SCEDC_Data/Northridge_1_year.txt'

Northridge_1_year_no_header='Data/Cleaned_Data/Northridge_1_year_no_header.txt' #rm at the end

Northridge_1_year_no_tail='Data/Cleaned_Data/Northridge_1_year_no_tail.txt' #rm at the end

Northridge_1_year_cleaned='Data/Cleaned_Data/Northridge_1_year_cleaned.txt'

Dates_time='dates_time.txt' #rm at the end

pre_1994='Data/Cleaned_Data/pre1994.txt'

Jan1994_April1994="Data/Cleaned_Data/Jan1994_April1994.txt"

April1994_July1994="Data/Cleaned_Data/April1994_July1994.txt"

July1994_Oct1994="Data/Cleaned_Data/July1994_Oct1994.txt"

Oct1994_Jan1995="Data/Cleaned_Data/Oct1994_Jan1995.txt"


#Editing the file 

awk 'NR>3' $Northridge_1_year > $Northridge_1_year_no_header

awk 'NR<11098' $Northridge_1_year_no_header > $Northridge_1_year_no_tail

awk '{print  $1, $2, $5, $7, $8, $9}' $Northridge_1_year_no_tail > $Northridge_1_year_cleaned


#Now I'm trying to get things into 3 month incremeents
awk '{a=substr($1,6,5); print a, $2}' $Northridge_1_year_cleaned > $Dates_time

#So there is probably a faster way of going this. What I ended up doing is I have a file with the dates. Then I just went
# through and used "control f" to find the row number for each start date I wanted 

#12:30:55

awk 'NR>=1 && NR<=6' $Northridge_1_year_cleaned > $pre_1994

awk 'NR>=7 && NR<=7924' $Northridge_1_year_cleaned > $Jan1994_April1994

awk 'NR>=7925 && NR<=9617' $Northridge_1_year_cleaned > $April1994_July1994

awk 'NR>=9618 && NR<=10485' $Northridge_1_year_cleaned > $July1994_Oct1994

awk 'NR>=10486 && NR<=NR' $Northridge_1_year_cleaned > $Oct1994_Jan1995

#Remove the files we no longer need 

rm $Northridge_1_year_no_header

rm $Northridge_1_year_no_tail

rm $Dates_time
