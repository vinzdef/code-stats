CCOUNT=0
TOTAL=0
NUM_LANGUAGES=0

echo '{' > ./results/languages.json.tmp

function parseLine {
    if [[ $1 == C ]]; then
        CCOUNT=$5

    elif [[ $1 == C/C++ ]]; then
        echo "  \"C\": $(( $CCOUNT+$6 ))" >> ./results/languages.json.tmp
        TOTAL=`expr $TOTAL + $CCOUNT + $6`

    elif [[ $1 == Bourne ]]; then
        echo "  \"Bash\": $6" >> ./results/languages.json.tmp
        TOTAL=`expr $TOTAL + $6`

    else 
        echo "  \"$1\" : $5" >> ./results/languages.json.tmp
        TOTAL=`expr $TOTAL + $5`
    fi
    NUM_LANGUAGES=`expr $NUM_LANGUAGES + 1`
}


I=0
while read line ; do
    ((I++))
    if [[ $line == Language* ]]; then
        break
    fi
done < ./results/raw/stats.txt

((I++))
J=0
while read line ; do 
   ((J++)) 
   if [[ $J -gt $I ]]; then
        if [[ $line == -* ]]; then
            break
        else parseLine $line
        fi
    fi
done < ./results/raw/stats.txt

echo '}' >> ./results/languages.json.tmp

I=0
while read line ; do     
    ((I++))
    if [[ $I -ge $NUM_LANGUAGES ]]; then
        #LAST LINE
        echo $line >> ./results/languages.json
        echo '}' >> ./results/languages.json
        break
    elif [[ $line == '{' ]]; then 
        #FIRST LINE
        echo $line > ./results/languages.json
    else 
        #MID LINE
        echo "$line," >> ./results/languages.json
    fi
done < ./results/languages.json.tmp

rm ./results/languages.json.tmp

#READ PAST NUMBER
PAST=$(cat ./results/raw/past.txt)
#BACKUP THE LAST PAST NUMBER JUST IN CASE
cp ./results/raw/past.txt ./results/raw/past.txt.bak
#OVERWRITE IT WITH THE NEW TOTAL
echo $TOTAL > ./results/raw/past.txt

#COMPUTE NEW PARTIAL
NEW=$(( $TOTAL - $PAST ))
#BACKUP OLD
cp ./results/raw/new.txt ./results/raw/new.txt.bak
#SAVE IT
echo $NEW > ./results/raw/new.txt

#NUMBER OF FILES COMPUTED
FILES=$(cat ./results/raw/stats.txt | grep -E 'SUM' | grep -Eo '[0-9]{0,}' | head -n 1) 

echo '{' > ./results/stats.json
echo "  \"Total\": $TOTAL," >>./results/stats.json
echo "  \"Past\": $PAST," >>./results/stats.json
echo "  \"Week\": $NEW," >>./results/stats.json
echo "  \"Files\": $FILES">>./results/stats.json
echo '}' >>./results/stats.json

cat ./results/languages.json
cat ./results/stats.json