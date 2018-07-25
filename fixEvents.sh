aRXNS=(NOR XOR EQU) #ORN OR ANDN
aINSTR=(Nop-A Nop-B Nop-C If-n-equ If-less Pop Push Swap-stk Swap Shift-r Shift-l Inc Dec Add Sub Nand IO H-alloc H-divide H-copy H-search Mov-head Jmp-head Get-head If-label Set-flow)
aCONC=(20 40 60 80 100)

cd cbuild
for INSTR in ${aINSTR[@]}
do
        for CONC in ${aCONC[@]}
        do
                cd work$INSTR$CONC
                for RXN in ${aRXNS[@]}
                do
                        cd run$RXN
                        sed -i "18s|../.*|../../work${RXN}/data/detail.spop|" events.cfg
                        cd ..
                done
                cd ..
        done
done
