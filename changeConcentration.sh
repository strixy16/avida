#more than one antibiotic on at once will probably have exact same random pattern
#assuming only one on at a time, may be bugs if try to combine (particularly if combine with nop)
CONCENTRATION=0  #default concentration is 0, aka work like normal, can just change number here

declare -A instr
declare -A rxn

#for nops, nop-A = 0, nop B = 1, nop C = 2 
#only one nop can be turned off at once
instr["NopA"]=false #nop only in sense of switching which registers get used, not label reading
instr["NopB"]=false 
instr["NopC"]=false 
instr["Ifnequ"]=false 
instr["Ifless"]=false 
instr["Iflabel"]=false 
instr["Movhead"]=false 
instr["Jmphead"]=false 
instr["Gethead"]=false 
instr["Setflow"]=false 
instr["Shiftr"]=false 
instr["Shiftl"]=false 
instr["Inc"]=false 
instr["Dec"]=false 
instr["Push"]=false
instr["Pop"]=false 
instr["Swapstk"]=false 
instr["Swap"]=false 
instr["Add"]=false 
instr["Sub"]=false 
instr["Nand"]=false 
instr["Hcopy"]=false 
instr["Halloc"]=false #added a return true
instr["Hdivide"]=false #as in divide avidian, not content of registers #added a return true
instr["IO"]=false 
instr["Hsearch"]=false

#list of reactions in environment defauult is to have on
rxn["NOT"]=true
rxn["NAND"]=true
rxn["AND"]=true
rxn["ORN"]=true
rxn["OR"]=true
rxn["ANDN"]=true
rxn["NOR"]=true
rxn["XOR"]=true
rxn["EQU"]=true


#if one of the nop instructions is turned on, which one
if [[ ${instr["NopA"]} = true ]]; then
	nop=0
elif [[ ${instr["NopB"]} = true ]]; then
	nop=1
elif [[ ${instr["NopC"]} = true ]]; then
	nop=2
fi


#setting concentration
cd avida-core/source/cpu #get to directory with cHardwareCPU

for i in "${!instr[@]}" 
do
	if [[ ${instr[$i]} = true ]]; then
		#nop is a special case as function for all types, not unique
		if [[ $i == Nop* ]]; then
			#this affects register and head function
			sed -i -E "s/(concentrationNop =) [0-9]+/\1 $CONCENTRATION/" cHardwareCPU.cc
			#this is what decides what nop gets affected
			sed -i -E "s/(nopType =) [0-9]+/\1 $nop/" cHardwareCPU.cc
		else
			sed -i -E "s/(concentration$i =) [0-9]+/\1 $CONCENTRATION/" cHardwareCPU.cc
		fi
		NAME=$i #save name of activated instruction, only one though
	fi
done

cd ../../.. #get back into avida

#if cbuild already built, checks if work folders that aren't allowed are there
if [ -d cbuild ]; then
	cd cbuild
	
	#if overlapping folder, create a folder called old<num> so can have multiple old folders in cbuild
	if [ -d work ] || [ -d work$NAME$CONCENTRATION ]; then
		NUM=1
		while [ -d old$NUM ]; do
			((NUM=NUM+1))
		done
		mkdir old$NUM
	fi
	
	#makes sure there isn't anything called work in cbuild
	if [ -d work ]; then
		echo "Folder called 'work', getting moved into old$NUM"
		mv work old$NUM
	fi
	#makes sure there isn't any same named work files in cbuild
	if [ -d work$NAME$CONCENTRATION ]; then
		echo "Folder called 'work$NAMECONCENTRATION', getting moved into old$NUM"
		mv work$NAME$CONCENTRATION
	fi
	
	cd ..	
fi


./build_avida #compiles new concentration

# change the name of work folder to be desciptive
#naming only work well with one instruction antibiotic turned on
cd cbuild
mv work work$NAME$CONCENTRATION
cd work$NAME$CONCENTRATION

#file so can keep track of concentrations and what instruction in case change name of work folder
touch concentration$CONCENTRATION
for i in "${!instr[@]}" 
do
	if [[ ${instr[$i]} = true ]]; then
		echo "$i is affected" >> concentration$CONCENTRATION
	fi
done

#make default copy mutation 0.0025
sed -i "49s/0.0075/0.0025/" avida.cfg


#only have reactions in environment.cfg that are set to true
for i in "${!rxn[@]}" 
do
	if [[ ${rxn[$i]} = false ]]; then
		#comment out if not true, space after $i is important so OR and ORN aren't confused
		sed -i -E "s/(REACTION  $i )/#\1/" environment.cfg
	fi
done


#return activated concentration to 0
#if turned on different instructions by hand, they'll stay the same
cd ../../avida-core/source/cpu #get to directory with cHardwareCPU

for i in "${!instr[@]}" 
do
	if [[ ${instr[$i]} = true ]]; then
		if [[ $i == Nop* ]]; then
			sed -i -E "s/(concentrationNop =) [0-9]+/\1 0/" cHardwareCPU.cc
			#returning nop to 0 technically unnecessary, but for consistency
			sed -i -E "s/(nopType =) [0-9]+/\1 0/" cHardwareCPU.cc
		else
			sed -i -E "s/(concentration$i =) [0-9]+/\1 0/" cHardwareCPU.cc
		fi
	fi
done
