#!/bin/bash

# Parse command-line arguments
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -f|--file)
        file="$2"
        shift # past argument
        shift # past value
        ;;
        -b|--bed)
        bed="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown option
        echo "Unknown option: $key"
        exit 1
        ;;
    esac
done

# Check if file and bed arguments are provided
if [ -z "$file" ] || [ -z "$bed" ]
then
    echo "At least one argument must be supplied (input file)."
    exit 1
fi

# Read flagged positions from csv file
#flag=$(cat $file)
file_complete=$(echo $file"/articNcovNanopore_prepRedcap_bammix_process/flagged_barcodes_positions_proportions.csv")

flag=$(awk -F ",\"" '{print $2}' $file_complete)

# Replace brackets with empty string in flagged positions
flag=$(echo $flag | sed 's/\[//g' | sed 's/\]//g')


# Loop through each flagged position
list_flag=()
for i in $flag
do
    #Convert string to array of numbers
    b=($(echo $i | sed 's/,/ /g' | sed 's/"/ /g'))
    # Add array to list of flagged positions
    list_flag+=(${b[@]})
    
done

#echo "${list_flag[@]}"

# # Sort list of flagged positions
list_flag_sorted=($(echo "${list_flag[@]}" | tr ' ' '\n' | sort -nu | tr '\n' ' '))

#echo "${list_flag_sorted[@]}"

# # Read primer pairs from bed file
primers=$(cat $bed)


# Sort primer pairs by second column
primers_sorted=$(echo "$primers" | sort -k2n)

#echo "$primers_sorted"
# Loop through each flagged position
#primerPairs=""
for i in ${list_flag_sorted[@]}
do
    # Find primer pairs that overlap with flagged position
    c=$(echo "$primers_sorted" | awk -v i="$i" '$2 < i && i < $3')
    echo "$c" >> test.bed

    # Add primer pairs to list
    #primerPairs+="$c"
    #echo "$primerPairs"
done

#
cat test.bed | sort -u | sort -k2n > flag_primerpair.bed

rm test.bed


# # Remove duplicate primer pairs
# primerPairs_uniq=$(echo -e "$primerPairs" | sort -u)

# # Write primer pairs to file
# echo -e "$primerPairs_uniq" #> flag_primerPair.bed

