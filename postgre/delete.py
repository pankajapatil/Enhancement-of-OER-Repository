import csv
import os
inpt = open('metadatavalue.txt');   #Enter full path here


output = open('metadata.csv','w+');


wr = csv.writer(output,delimiter='\t', quoting=csv.QUOTE_ALL) #get csv writer object

lines = inpt.readlines();
i=1;
for line in lines:
	line = line.split('\t');
	if(line[1] == '63'):
			wr.writerow([line[7].rstrip(),line[2].rstrip()]);
inpt.close()
output.close()
