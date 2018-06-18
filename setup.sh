TASKS=(NOT NAND AND ORN OR ANDN NOR XOR EQU)
INSTR=(Nop-A Nop-B Nop-C If-n-equ If-less Pop Push Swap-stk Swap Shift-r Shift-l Inc Dec Add Sub Nand IO H-alloc H-divide H-copy H-search Mov-head Jmp-head Get-head If-label Set-flow)
CONC=(20 40 60 80 100)

for INSTR in ${INSTR[*]}
do
	for CONC in ${CONC[*]}
	do
		cd work$INSTR$CONC
		sed - i "49s/0.0075/0.0025/" avida.cfg
		mkdir run 
		mv * run/
		CNTR=0
		for TASKS in ${TASKS[*]}
		do
			CNTR=$((CNTR+1))
			cp run run$TASKS
			LINE=$((14+CNTR))
			sed -i "s/-1/$TASKS/" avida.cfg
			sed -i "s/Inject default-heads.cfg/LoadPopulation ../work$TASKS/data/detail50000.spop/" events.cfg
			for I in 15 16 17 18 19 20 21 22 23 
			do 
				if [ I -gt LINE ] || [ I -lt LINE]
				then
					sed -i "{I}s/"

