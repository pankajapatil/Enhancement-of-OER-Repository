import csv;
import pandas
import warnings
import string
import numpy as np
warnings.filterwarnings('ignore')
from sklearn.feature_extraction.text import CountVectorizer,TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

PATH = '/home/abc/Downloads/postgre/';

f = open(PATH+'metadata.csv');
reader = csv.reader(f,delimiter = '\t');
obj_id = open(PATH+'obj_id.csv','w+');
wr = csv.writer(obj_id);


data = dict()
for obj,keyword in reader:	
	if obj in data:
		data[obj].append(keyword.rstrip());
	else:
		data[obj] = [keyword.rstrip()];
		
for obj in data.keys():
	wr.writerow([obj]);      #writing object_id's into csv to use later in recommendation mapping

corpus = []

for list in data.values():
	corpus.append(' '.join(list));

tf = TfidfVectorizer(analyzer='word',min_df=1)
X = tf.fit_transform(corpus)
cosine_sim = cosine_similarity(X);

for i in range(0,len(corpus)):
	cosine_sim[i,i]=0;
np.savetxt(PATH+'scores.txt',cosine_sim,delimiter = ',');  #store similarity matrix in buffer .....


matrix = []
for row in cosine_sim:
	matrix.append([i[0] for i in sorted(enumerate(row),key = (lambda x:x[1]),reverse = True)])

np.savetxt(PATH+'ranks.txt',matrix,delimiter = ',');  #store similarity matrix in buffer .....

	
