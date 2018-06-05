import os
paths = [element for element in os.listdir("cbuild/DidNotRun") if os.path.isdir(os.path.join("cbuild/DidNotRun", element)) & element.startswith("run")]
for i in range(1,len(paths)+1):
    detail = "cbuild/DidNotRun/run"+str(i)+"/detail-6000.spop"
    file = open(detail, 'r')
    datalines = file.readlines()
    dominant = 0
    for k in range(0, len(datalines)):
        columns = datalines[k].split()
        if len(datalines[k].strip()) == 0:
            continue
        if columns[0] == '#' or columns[0] == "#filetype" or columns[0]=="#format":
            continue
        if len(columns) > 18:
            cells = columns[17].split(',')
        if len(cells) > dominant:
            dominant = len(cells)
            line = k+1
            idd = columns[0]
    print "The number of dominant organisms: %s" %dominant
    print "The line in the detail file: %d" %line
   

