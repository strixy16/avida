RXNS=(ORN OR ANDN NOR XOR EQU)
INSTR=(Nop-A Nop-B Nop-C If-n-equ If-less Pop Push Swap-stk Swap Shift-r Shift-l Inc Dec Add Sub Nand IO H-alloc H-divide H-copy H-search Mov-head Jmp-head Get-head If-label Set-flow)
CONC=(20 40 60 80 100)

cd cbuild
for INSTR in ${INSTR[*]}
do
	for CONC in ${CONC[*]}
	do
		cd work$INSTR$CONC   #go into the specific work folder
		sed -i "49s/0.0075/0.0025/" avida.cfg  #change its copy mutation
		mkdir run 
		mv * run/    #move all the files into run
		CNTR=0
		for RXN in ${RXNS[*]}
		do
			CNTR=$((CNTR+1))	#gonna need this for the environment file
			cp -R run run$RXN		#make folder for specific task
			LINE=$((17+CNTR))	#same as CNTR
			cd run$RXN
			sed -i "153s/-1/$RXN/" avida.cfg	#change the required reaction
			sed -i "17s/^/#/" events.cfg
			sed -i "18iu begin LoadPopulation ../work$RXN/data/detail-50000.spop" events.cfg
			for I in 15 16 17 18 19 20 21 22 23 
			do 
				if [[ I -gt LINE ]] || [[ I -lt LINE ]]	#
				then
					sed -i "${I}s/^/#/" environment.cfg
				fi
			done 
			cd ..
		done 
		rm -R run/
		cd ..
	done 
done 


