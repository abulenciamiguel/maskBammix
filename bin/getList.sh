#!/bin/bash
#remove the last backslash if found on the last name of the directory
dir_corrected=$(echo $1 | sed 's/\/$//')


#get the list of fasta files in the directory
ls $dir_corrected/*.fasta | awk -F "/" '{print $NF}' | sed 's/.fasta//g' > consensus_list.csv

#create 2 columns containing the name of the file and the directory where it can be found
awk -i inplace -v dir=$dir_corrected '{print $0","dir"/"$0".fasta"}' consensus_list.csv

#create column headers
sed -i '1 i\sample,directory' consensus_list.csv