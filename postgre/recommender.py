# Author prasad@travelMatepc.iitb.ekalvya   Date: 13 Jun 2018 

import warnings
warnings.filterwarnings("ignore")
import numpy as np
import string
import operator
import pandas as pd
import csv
import os
import sys
import datetime
import gc

PATH ='/home/dspace/Downloads/postgre/'
out = open(PATH+"out1.txt",'w');
now = str(datetime.datetime.now()).split();
fName = "/home/dspace/log/dspace.log."+now[0];	
fieldnames = ['user','ip','handle']
myfile = open(PATH+'log.csv','w')
wr = csv.DictWriter(myfile,fieldnames=fieldnames,quoting=csv.QUOTE_ALL)	
if os.path.exists(fName):
	f = open(fName,"r") 
	lines = f.readlines()
	for line in lines:
		split_list = line.split(":")
		if(len(split_list)>5 and (  split_list[5].startswith("view_item"))):        
			user = split_list[2][split_list[2].find("@")+2:]
			ip_address = split_list[4][split_list[4].find("=")+1:]
			event_id = split_list[6][split_list[6].find("=")+1:].rstrip()       
			wr.writerow({'user':user,'ip':ip_address,'handle':event_id})
	f.close()
os.system('(head -n 1 log.csv  && tail -n +2 log.csv | sort | uniq) > log.csv')
#to save only unique lines in the csv file in the sorted order without altering the header row 
myfile.close()


# loading model(similarity matrix) into a matrix
gc.collect()   # used to collect memory leaks
cosine_sim = np.loadtxt(open(PATH+"scores.txt","rb"),delimiter=",",skiprows=0);
ranks = np.loadtxt(open(PATH+'ranks.txt','rb'),delimiter = ',' ,skiprows=0);

# reading parsed log file
log = pd.read_csv(PATH+'log.csv',names=['user','ip','handle'])          # provide column names...


log = log[(log['user'] == str(sys.argv[1]))]               # to get history of specific user...

handle = pd.read_csv(PATH+'handle.csv',names = ['handle','obj_id'],delimiter='\t')# Note that postgre copy always follows tab seperated not,seperated

handle = pd.merge(log,handle,on = 'handle');                       # join tables on handle_id


viewed_obj_ids = handle.obj_id.tolist();		           # to get obj_ids related to handles of userviewed items

total_obj_ids = pd.read_csv(PATH+'obj_id.csv',names=['obj_id'])

obj_id = total_obj_ids.obj_id.isin(viewed_obj_ids)                 # checking each obj_id in keyword table is belongs to user viewed 
# user viewed obj_id places become true in total obj list                                                      # .... obj_id list

indices = obj_id[obj_id == True].index.tolist()			   # final indices of user_viewed objs to get similar items with help
								                       # .... of already calculated similarity matrix
total_obj_ids = total_obj_ids.obj_id.tolist();

recom = dict();
MAX = 4 ;	# number of items similar to each viewed item				
if(MAX > len(total_obj_ids)):		# Generally we'll take past(10-20) 10 items * 4 similar = 40 items
	MAX = len(total_obj_ids)-1;     # if total objects are less than 4; just for exception handling
for i in indices:               # for each user viewed object we take its number as i
	for j in range(0,MAX):  # get MAX similar items from rank matrix as indexes
		k = ranks[i,j].astype(int)    # get next similar item to item i
		if not (k in indices or cosine_sim[i,k]==0):  # the similar item should be fresh item		
			if(k in recom):
				recom[k] = recom[k]+cosine_sim[i,k];
			else:
				recom[k] = cosine_sim[i,k];

# sort recommendations by similarity score if u again wana filteration by scoring
#recom = [i[0] for i in sorted(recom,key = (lambda x:x[1]),reverse = True)]

recom = sorted(recom.items(), key=lambda recom:recom[1],reverse = True)

total = 10;
if(total > len(recom)):
	total = len(recom);
for i in range(0,total):
	out.write(total_obj_ids[recom[i][0]]+"\n");
out.close();
