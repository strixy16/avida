#!/bin/bash

#SBATCH -c 2
#SBATCH --mem=5072
#SBATCH --time=0-4:0:00

SCRIPT=submission.sh

LESSRUN=(Movhead+20 Iflabel+20 IO+40 Swap+60 Nand+60 IO+60 Halloc+60 Hsearch+60 Hdivide+80 Nand+80 Halloc+80 NopC+100 Hcopy+100 Hsearch+100)


#comment out aRXNS INSTR aCONC
sed -i -E "s/^(a.*=)/#\1/" variables.sh

#put in all reactions
sed -i -E "1s/^/aRXNS=(NOT NAND AND)\n/" variables.sh

#loop will run all combos
TEMP=()
OLDCONC=$(cut -d "+" -f2 <<< $LESSRUN)

for i in ${LESSRUN[@]}; do
    INSTR=$(cut -d "+" -f1 <<< $i)
    CONC=$(cut -d "+" -f2 <<< $i)

    if [[ $OLDCONC == $CONC ]]; then
        TEMP+=($INSTR)
    else
        LIST=${TEMP[@]}
        sed -i -E "2s/^/aCONC=($(($OLDCONC-15)) $(($OLDCONC-10)) $(($OLDCONC-5)))\n/" variables.sh
        sed -i -E "3s/^/aINSTR=($LIST)\n/" variables.sh
        sh $SCRIPT
        wait
        #get rid of conc and instr
        sed -i -E "/^aCONC=/d" variables.sh
        sed -i -E "/^aINSTR=/d" variables.sh
        TEMP=($INSTR)
    fi

    OLDCONC=$CONC

done
LIST=${TEMP[@]}
sed -i -E "2s/^/aCONC=($(($OLDCONC-15)) $(($OLDCONC-10)) $(($OLDCONC-5)))\n/" variables.sh
sed -i -E "3s/^/aINSTR=($LIST)\n/" variables.sh
sh $SCRIPT
wait
#get rid of conc and instr
sed -i -E "/^aCONC=/d" variables.sh
sed -i -E "/^aINSTR=/d" variables.sh

#get rid of reaction line
sed -i -E "/^aRXNS=/d" variables.sh

#uncomment the old settings
sed -i -E "s/^#//" variables.sh