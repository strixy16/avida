CONCENTRATION=50 #default concentration is 20, can just change number here

#setting concentration
cd avida-core/source/cpu #get to directory with cHardwareCPU
sed -i "2962s/20/$CONCENTRATION/" cHardwareCPU.cc 

cd ../../.. #get back into avida
./build_avida #compiles new concentration

#setting it up to run the way runAnti.sh can accept
cd cbuild
mv work workantiadd

cd workantiadd
mkdir populations #folder to hold populations that can be loaded
touch concentration$CONCENTRATION

#make default copy mutation 0.0025
sed -i "49s/0.0075/0.0025/" avida.cfg

#make it well mixed
sed -i "94s/0/4/" avida.cfg

#load population line instead of inject
sed -i "17s/Inject default-heads.org/LoadPopulation populations\/detail.spop/" events.cfg

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
sed -i "2962s/$CONCENTRATION/20/" cHardwareCPU.cc

