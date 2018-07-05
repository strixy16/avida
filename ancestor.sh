# Create ancestor work folders for use in antibiotic trials
#!/bin/bash

#SBATCH -c 3
#SBATCH --mem=1024
#SBATCH --time=0-3:0:00

source ./variables.sh

#aRXNS=(NOT NAND AND ORN OR ANDN NOR XOR EQU)

cd cbuild
for RXN in ${aRXNS[*]}
do
	cp -R work work$RXN
	cd work$RXN

	# NOT through ANDN settings
	if [[ $RXN != "NOR" ]] &&  [[ $RXN != "XOR" ]] && [[ $RXN != "EQU" ]]
	then
		# Disable all reactions except desired reaction in environment file 
		sed -i "s/REACTION/#REACTION/" environment.cfg
		sed -i "s/#REACTION\s+$RXN/REACTION  $RXN/" environment.cfg
	# NOR, XOR, EQU require all reactions below them to be enabled
	elif [[ $RXN == "NOR" ]]
	then
		sed -i -E "s/REACTION\s+XOR/#REACTION  XOR/" environment.cfg
		sed -i -E "s/REACTION\s+EQU/#REACTION  EQU/" environment.cfg
	elif [[ $RXN == "XOR" ]]
	then
		EQUline=$(($LINE + 1))
		sed -i -E "s/REACTION\s+EQU/#REACTION  EQU/" environment.cfg
	#EQU leaves all REACTIONS active
	else
		continue
	fi
	cd ..
done

