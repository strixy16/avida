#!/bin/bash
# Set-up/choose populations to use for antibiotic trials in ancestor directories

# Import aRXNS list
source ./variables.sh

# Boolean for adequate population
FOUND=0

cd cbuild

for RXN in ${aRXNS[*]}
do
	if [[ $RXN == XOR ]] || [[ $RXN == EQU ]]
	then
		cd work$RXN
		FOUND=0
		for i in {1..5}
		do
			cd data$i

			# Check if the run made it to the expected number of updates
			if [[ ! -e "detail-${POPUPDATES}.spop" ]]
			then
				# If population didn't complete run, try next one	
				cd .. 
				continue
			fi

			# Check if population can achieve reaction
			if ! grep -q "$POPUPDATES" tasks.dat
			then
				# Population cannot do reaction
				cd ..
				continue
			fi	

			# Check that dominant organism can do reaction
			if grep -q -i "$RXN 0" archive/*
			then
				# Dominant did not perform reaction
				cd ..
				continue
			fi	

			# Population can be used for experiment
			# Set up for antibiotic trial
			cp detail-$POPUPDATES.spop detail.spop
			cd ..
			cp -R data$i data
			FOUND=1
			break

		done
		if [[ $FOUND == 0 ]]
		then
			# None of the populations can be used
			echo "No $RXN populations evolved sufficiently for experiment use."
		fi
	else
		# For everything but XOR and EQU
		cd work$RXN/data1

		# Check that the run made it to the expected number of updates
		if [[ ! -e "detail-${POPUPDATES}.spop" ]]
		then
			# If population didn't complete run, exit	
			echo "$RXN population did not reach $POPUPDATES updates."
			exit
		fi

		# Check that population can achieve reaction
		if ! grep -q "$POPUPDATES" tasks.dat
		then
			echo "$RXN population is not able to do $RXN"
			exit
		fi	

		cp detail-${POPUPDATES}.spop detail.spop
		cd ..
		cp -R data1 data
		cd ..
	fi
done
