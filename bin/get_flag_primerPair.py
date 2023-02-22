#!/usr/bin/env python3

import pandas as pd
import argparse


parser = argparse.ArgumentParser(description='Flagging primer pairs')
parser.add_argument("--dir", required=True, type=str, help="directory where the csv file is located")
parser.add_argument("--bed", required=True, type=str, help="directory where the bed file is located")


args = parser.parse_args()


dir_csv = args.dir
file_bed = args.bed


# Read the flagged barcodes positions proportions file into a DataFrame
flag = pd.read_csv(dir_csv+"/flagged_barcodes_positions_proportions.csv", sep=",", header=0)

# Clean the 'positions' column by removing the square brackets
flag['positions'] = flag['positions'].str.replace(r'\[|\]', '')

# Create a list to store the primer pairs
list_flag = []

# Iterate through each row of the 'positions' column
for position in flag['positions']:
	# Convert the string of comma-separated numbers to a list of integers
	b = [int(x) for x in position.split(",")]

	# Add the list to the primer pairs list
	list_flag.append(b)

# Flatten the list and sort it
list_flag_sorted = sorted([item for sublist in list_flag for item in sublist])

# Read the primers file into a DataFrame
primers = pd.read_csv(file_bed, sep="\t", header=None)

# Sort the primers DataFrame by the second column
primers_sorted = primers.sort_values(by=1)

# Create an empty DataFrame to store the primer pairs
primerPairs = pd.DataFrame(columns=["V1", "V2", "V3"])

# Iterate through each position in the sorted list
for i in list_flag_sorted:
	# Select the primers that flank the current position
	c = primers[(primers[1] < i) & (primers[2] > i)]

	# Add the primer pairs to the DataFrame
	primerPairs = primerPairs.append(c)

# Remove duplicate primer pairs
primerPairs_uniq = primerPairs.drop_duplicates()

# Write the primer pairs to a file
primerPairs_uniq.to_csv("flag_primerPair.bed", sep="\t", header=False, index=False)

