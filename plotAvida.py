## Generate plots for Avida antibiotic trials

import matplotlib.pyplot as plt
import os
import datetime

# List of possible reactions
reactions = ["NOT", "NAND", "AND", "ORN", "OR", "ANDN", "NOR", "XOR", "EQU"]

# List of instruction objects
instrList = []

# Reaction object, contains concentration and success data
class rxnData:
    def __init__(self, name):
        self.name = name
        self.xData = []
        self.yData = []

    # X will be concentrations, Y the rate of successful evolution
    def addXY(self, X, Y):
        self.xData.append(X)
        self.yData.append(Y)

# Instruction object, contains reaction objects
class instrData:
    def __init__(self, name):
        self.name = name
        self.rxns = []      # List of rxnData objects

    def addRXN(self, RXN):
        self.rxns.append(RXN)

    #def plot(self):

# Data file to analyze
tasks = open("taskData", "r")
lines = [line.split() for line in tasks]
# lines[i][0] = concentration level
# lines[i][1] = number of updates reached
# lines[i][2] = population size at last update

rxnName = ""
instrName = ""
RXN = None    # Reaction object to be created
INSTR = None  # Instruction object to be created
prevConc = 0  # Concentration on previous data line
sCount = 0    # Success counter
trials = 0.0  # Trial counter

k = 0  #line number
while k < len(lines):
    if(len(lines[k]) == 1):                  # Check if it's data or a RXN/INSTR
        # If a new RXN is reached in file, add data to previous RXN object and reset concentration
        if RXN != None and prevConc != 0:
            sRate = sCount/trials
            RXN.addXY(prevConc, sRate)
            prevConc = 0

        if(lines[k][0] in reactions):       # Checks if reaction
            rxnName = lines[k][0]
        else:
            instrName = lines[k][0]         # Checks if instruction
            # check if instrData object already exists for instrName
            # returns [] if no, returns list of objects with instrName if yes
            INSTR = [item for item in instrList if item.name == instrName]
            if (INSTR == []):
                INSTR = instrData(instrName)
                instrList.append(INSTR)      # If not in list, create one and add it to the list
            else:
                INSTR = INSTR[0]
            RXN = rxnData(rxnName)
            INSTR.addRXN(RXN)               # Add rxn to list of rxns in instruction object
        k+=1
    else:   # Otherwise is a line of data
        #i = 0
        currConc = lines[k][0]
        # New concentration reached
        if(currConc != prevConc):
            if(prevConc != 0):
                # Find probability of success as a decimal
                sRate = sCount/trials
                # Add data to RXN object
                RXN.addXY(prevConc, sRate)
            trials = 0.0
            sCount = 0
            prevConc = currConc
        # Checks if this trial was successful at evolving
        if(lines[k][1] == "100000"):
            sCount+=1
        trials+=1
        k+=1

# Add last section of data to RXN object (loop doesn't reach this point)
sRate = sCount/trials
RXN.addXY(currConc, sRate)

# Make directory for storing plots
now = datetime.datetime.now()
directory = "avida_plots_" + str(now.year)+str(now.month)+str(now.day)+"_"+str(now.hour)+":"+str(now.minute)
if not os.path.exists(directory):
    os.makedirs(directory)
    
# List for x axis ticks
xpoints=[]
# Plotting each of 26 instructions with all reactions
for instr in instrList:
    # Get concentrations as x axis ticks
    xpoints=[]
    for rxn in instr.rxns:
        # Get all possible concentrations from each reaction/instruction pair
        xpoints = xpoints + rxn.xData

    # Convert to set to get unique concentrations, sort set, cast to integer for use in xticks
    xunique = map(int, sorted(set(xpoints)))
    
    plt.figure()
    plt.title(instr.name)
    plt.xticks(xunique)
    plt.yticks([0, 0.2, 0.4, 0.6, 0.8, 1.0])
    plt.xlabel('Concentration')
    plt.ylabel('Probability of Successful Evolution')
    for rxn in instr.rxns:
        #print(instr.name, ", ", rxn.name, ": ", rxn.xData, rxn.yData)
        plt.plot(rxn.xData, rxn.yData, label=rxn.name, alpha=0.5, linewidth=2.0)

    # Set axes so all possible data is visible
    axes = plt.gca()
    axes.set_ylim([-0.1,1.1])
    box = axes.get_position()
    # Shrink axes so legend is visible
    axes.set_position([box.x0, box.y0, box.width * 0.9, box.height])
    axes.legend(loc='center left', bbox_to_anchor=(1, 0.5))
    plt.draw()
    plt.savefig(directory + "/" + instr.name + '.pdf')
    # plt.show()       # pulls up each plot one at a time

#plt.show() # shows all 26 plots, will get Runtime Warning about this
