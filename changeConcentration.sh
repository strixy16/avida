#settings to set
#more than one antibiotic on at once will probably have exact same random pattern
#assuming only one on at a time, may be bugs if try (particularly if combine with nop)
CONCENTRATION=20 #default concentration is 0, can just change number here

declare -A instr
# declare -A rxn

#for nops, 1628 matters nop-A = 0, nop B = 1, nop C = 2 (default 0)
#1676 matters as well for head switching
instr["Nop-A"]=false #nop only in sense of switching which registers get used, not label reading
instr["Nop-B"]=false 
instr["Nop-C"]=false 
instr["If-N-Eq"]=false 
instr["If-Less"]=false 
instr["If-Label"]=false 
instr["Mov-Head"]=false 
instr["Jmp-Head"]=false 
instr["Get-Head"]=false 
instr["Set-Flow"]=true
instr["Shift-R"]=false 
instr["Shift-L"]=false 
instr["Inc"]=false 
instr["Dec"]=false 
instr["Push"]=false
instr["Pop"]=false 
instr["Swap-Stk"]=false 
instr["Swap"]=false 
instr["Add"]=false 
instr["Sub"]=false 
instr["Nand"]=false 
instr["H-Copy"]=false 
instr["H-Alloc"]=false #added a return true
instr["H-Divide"]=false #as in divide avidian, not content of registers #added a return true
instr["Io"]=false 
instr["H-Search"]=false

#don't use for giant loop
#list of reactions work folder can automatically have on
# rxn["NOT"]=false
# rxn["NAND"]=false
# rxn["AND"]=false
# rxn["ORN"]=false
# rxn["OR"]=false
# rxn["ANDN"]=false
# rxn["NOR"]=false
# rxn["XOR"]=false
# rxn["EQU"]=false

declare -A lineNum

#for nops, 1628 matters Nop-A = 0, nop B = 1, nop C = 2 (default 0)
#1676 matters as well for head switching
lineNum["Nop-A"]=1627 #1675) #nop only in sense of switching which registers get used, not label reading
lineNum["Nop-B"]=1627 #1675) 
lineNum["Nop-C"]=1627 #1675)
lineNum["If-N-Eq"]=2208
lineNum["If-Less"]=2258
lineNum["If-Label"]=7023
lineNum["Mov-Head"]=6902
lineNum["Jmp-Head"]=6957
lineNum["Get-Head"]=7011
lineNum["Set-Flow"]=7400
lineNum["Shift-R"]=2856
lineNum["Shift-L"]=2868
lineNum["Inc"]=2924
lineNum["Dec"]=2936
lineNum["Push"]=2738
lineNum["Pop"]=2726
lineNum["Swap-Stk"]=2776
lineNum["Swap"]=2787
lineNum["Add"]=3029
lineNum["Sub"]=3042
lineNum["Nand"]=3096
lineNum["H-Copy"]=7250
lineNum["H-Alloc"]=3376 #added a return true
lineNum["H-Divide"]=7075 #as in divide avidian, not content of registers #added a return true
lineNum["Io"]=4276 
lineNum["H-Search"]=7370 


# sed -i "/REACTION/s/^/#/" environment.cfg
# sed -i "15s/#//" environment.cfg
# #inflow/outflow on not line
# sed -i "15s/process/process:resource=resNOT/" environment.cfg

#setting concentration
cd avida-core/source/cpu #get to directory with cHardwareCPU

for i in "${!instr[@]}" 
do
	if [[ ${instr[$i]} = true ]]; then
		sed -i "${lineNum[$i]}s/0/$CONCENTRATION/" cHardwareCPU.cc
		NAME=$i #will only work if only 1 turned on
		#need to change 2 functions for nop, only gave one to array
		if [[ $i == NOP-* ]]; then
			sed -i "1675s/0/$CONCENTRATION/" cHardwareCPU.cc
			#not NOP-A as default is 0, which is NOP-A
			if [[ $i == NOP-B ]]; then
				sed -i "1628s/0/1/" cHardwareCPU.cc
				sed -i "1676s/0/1/" cHardwareCPU.cc
			fi
			if [[ $i == NOP-C ]]; then
				sed -i "1628s/0/2/" cHardwareCPU.cc
				sed -i "1676s/0/2/" cHardwareCPU.cc
			fi
		fi
	fi
done

cd ../../.. #get back into avida
./build_avida #compiles new concentration

#setting it up to run the way runAnti.sh can accept
cd cbuild
mv work work$NAME$CONCENTRATION

cd work$NAME$CONCENTRATION
# mkdir populations #folder to hold populations that can be loaded

#file so can keep track of concentrations
# touch concentration$CONCENTRATION
# for i in "${!instr[@]}" 
# do
# 	if [[ ${instr[$i]} = true ]]; then
# 		echo "$i is affected" >> concentration$CONCENTRATION
# 	fi
# done

#make default copy mutation 0.0025
sed -i "49s/0.0075/0.0025/" avida.cfg

#make it well mixed
sed -i "94s/0/4/" avida.cfg

#load population line instead of inject
# sed -i "17s/Inject default-heads.org/LoadPopulation populations\/detail.spop/" events.cfg

#only have reaction
# rxnline=("NOT" "NAND" "AND" "ORN" "OR" "ANDN" "NOR" "XOR" "EQU")
# #comments them all out
# sed -i "/REACTION/s/^/#/" environment.cfg
# #rxn line number
# for (( i = 0; i < 9; i++ )); do
# 	if [[ ${rxn[${RXNS[$i]}]} == true ]]; then
# 		sed -i "$((i+15))s/#//" environment.cfg
# 	fi	
# done
# for i in ${rxn[$i]}; do
# 	if [[ ${rxn[$i]} == true ]]; then
# 		sed -i "$"
# 	fi
# done


# #so next time run this it works
cd ../../avida-core/source/cpu #get to directory with cHardwareCPU
#setting concentration
for i in "${!instr[@]}" 
do
	if [[ ${instr[$i]} = true ]]; then
		sed -i "${lineNum[$i]}s/$CONCENTRATION/0/" cHardwareCPU.cc
		if [[ $i == NOP-* ]]; then
			sed -i "1675s/$CONCENTRATION/0/" cHardwareCPU.cc
			#not NOP-A as default is 0, which is NOP-A
			if [[ $i == NOP-B ]]; then
				sed -i "1628s/1/0/" cHardwareCPU.cc
				sed -i "1676s/1/0/" cHardwareCPU.cc
			fi
			if [[ $i == NOP-C ]]; then
				sed -i "1628s/2/0/" cHardwareCPU.cc
				sed -i "1676s/2/0/" cHardwareCPU.cc
			fi
		fi
	fi
done
