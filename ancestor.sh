# Create ancestor work folders for use in antibiotic trials
#!/bin/bash

#SBATCH -c 3
#SBATCH --mem=1024
#SBATCH --time=0-3:0:00

aRXNS=(NOT NAND AND ORN OR ANDN NOR XOR EQU)

CNTR=0
cd cbuild
for RXN in ${aRXNS[*]}
do
	cp -R work work$RXN
	cd work$RXN

	# Find line number for reaction in question
	LINE=$(grep -n " $RXN " environment.cfg | cut -f1 -d:)

	# NOT through ANDN settings
	if [[ $RXN != "NOR" ]] &&  [[ $RXN != "XOR" ]] && [[ $RXN != "EQU" ]]
	then
		# Disable all reactions except desired reaction in environment file 
		sed -i "s/REACTION/#REACTION/" environment.cfg
		sed -i "${LINE}s/#REACTION/REACTION/" environment.cfg
		# NOR, XOR, EQU require all reactions below them to be enabled
	elif [[ $RXN == "NOR" ]]
	then
		XORline=$(($LINE + 1))
		EQUline=$(($LINE + 2))
		sed -i "${XORline}s/REACTION/#REACTION/" environment.cfg
		sed -i "${EQUline}s/REACTION/#REACTION/" environment.cfg
	elif [[ $RXN == "XOR" ]]
	then
		EQUline=$(($LINE + 1))
		sed -i "${EQUline}s/REACTION/#REACTION/" environment.cfg
	else
		continue
	fi
	cd ..
done

