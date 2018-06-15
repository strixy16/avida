#settings to set
#more than one antibiotic on at once will probably have exact same random pattern
CONCENTRATION=100 #default concentration is 0, can just change number here
ADD=false
SUB=false
NAND=true
COPY=false
DIVIDE=false #as in divide avidian, not content of registers
#this arrangment works for only not, change environment file if want different

#setting concentration
cd avida-core/source/cpu #get to directory with cHardwareCPU
if $ADD; then
	sed -i "2962s/0/$CONCENTRATION/" cHardwareCPU.cc 
fi

if $SUB; then
	sed -i "2975s/0/$CONCENTRATION/" cHardwareCPU.cc
fi

if $NAND; then
	sed -i "3029s/0/$CONCENTRATION/" cHardwareCPU.cc
fi

if $COPY; then
	sed -i "3136s/0/$CONCENTRATION/" cHardwareCPU.cc
fi

if $DIVIDE; then
	sed -i "3282s/0/$CONCENTRATION/" cHardwareCPU.cc
fi

cd ../../.. #get back into avida
./build_avida #compiles new concentration

#setting it up to run the way runAnti.sh can accept
cd cbuild
mv work work_all

cd work_all
#mkdir populations #folder to hold populations that can be loaded

#file so can keep track of concentrations
touch concentration$CONCENTRATION
if $ADD; then
	echo "add is affected" >> concentration$CONCENTRATION
fi

if $SUB; then
	echo "sub is affected" >> concentration$CONCENTRATION
fi

if $NAND; then
	echo "nand is affected" >> concentration$CONCENTRATION
fi

if $COPY; then
	echo "copy is affected" >> concentration$CONCENTRATION
fi

if $DIVIDE; then
	echo "divide is affected" >> concentration$CONCENTRATION
fi

#make default copy mutation 0.0025
sed -i "49s/0.0075/0.0025/" avida.cfg

#make it well mixed
sed -i "94s/0/4/" avida.cfg

#load population line instead of inject
#sed -i "17s/Inject default-heads.org/LoadPopulation populations\/detail.spop/" events.cfg

#print the genotype of the dominant
sed -i "28s/#/ /" events.cfg

#only have not
sed -i "/REACTION/s/^/#/" environment.cfg
sed -i "15s/#//" environment.cfg
#inflow/outflow on not line
sed -i "15s/process/process:resource=resNOT/" environment.cfg

#get inflow and outflow for resource not
sed -i "13 a RESOURCE  resNOT:inflow=10:outflow=0.01" environment.cfg

#so next time run this it works
cd ../../avida-core/source/cpu #get to directory with cHardwareCPU
if $ADD; then
	sed -i "2962s/$CONCENTRATION/0/" cHardwareCPU.cc 
fi

if $SUB; then
	sed -i "2975s/$CONCENTRATION/0/" cHardwareCPU.cc
fi

if $NAND; then
	sed -i "3029s/$CONCENTRATION/0/" cHardwareCPU.cc
fi

if $COPY; then
	sed -i "3136s/$CONCENTRATION/0/" cHardwareCPU.cc
fi

if $DIVIDE; then
	sed -i "3282s/$CONCENTRATION/0/" cHardwareCPU.cc
fi

