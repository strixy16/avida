#!bin/bash
aRXNS=(ORN OR ANDN NOR XOR EQU)
aINSTR=Set-Flow     #(Nop-A Nop-B Nop-C If-n-equ If-less Pop Push Swap-stk Swap Shift-r Shift-l Inc Dec Add Sub Nand IO H-alloc H-divide H-copy H-search Mov-head Jmp-head Get-head If-label Set-flow)
aCONC=20   #(20 40 60 80 100)

for INSTR in ${aINSTR[@]} 
do
	for CONC in ${aCONC[@]}
	do
		for RXN in ${aRXNS[@]}
		do
			sed -i "11s|work|work$INSTR$CONC/run$RXN|" multi.sh
			./multi.sh
			sed -i "11s|work$INSTR$CONC/run$RXN|work|" multi.sh
		done
	done
done
