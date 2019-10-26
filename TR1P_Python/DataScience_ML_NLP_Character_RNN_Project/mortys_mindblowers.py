# Morty's Mindblowers 
# Description: Data Science FTW
# Poorly Written By: Gomez, Timothy D. (Tr1p)
# Date: 3 May 2019
# Task Key Words: New, DataFrame, KeySpace, Pattern, NLP, Cracking, Passwords
# License: MIT 
import string, codecs, os, pathlib2, json, re
import pandas as pd
import numpy as np
from nltk.corpus import stopwords
from nltk.stem import SnowballStemmer
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.svm import LinearSVC
from sklearn.pipeline import Pipeline
from sklearn.model_selection import train_test_split
from sklearn.feature_selection import SelectKBest, chi2
from sklearn.feature_extraction.text import CountVectorizer

# Create 4x Char Pattern index from input file
with open('/cracking/not_optimized_wordlists/4x4_kbwalk_all.txt','r') as file_data:
    stage1 = pd.Series([x.strip() for x in file_data.readlines()])

# I should have a map of the characters in the set
def walk_ascii_map(c):
    x = "{0:02x}".format(ord(c))
    y = int(ord(c))
    z = str(c)
    return z,y,x

# load in keyspace reference
with open('/cracking/not_optimized_wordlists/4x4_kbwalk_all.txt','r') as file_data:
    charSet = set()
    for a in file_data.readlines():
        for b in list(a.strip()):
            if b in string.ascii_letters: # not today ISIS
                charSet.add(walk_ascii_map(b.lower())) 
                charSet.add(walk_ascii_map(b.upper()))
            else:
                charSet.add(walk_ascii_map(b))
    # Make a DataFrame from the keyspace input
    df_charSet = pd.DataFrame.from_records(data=list(sorted(charSet)))

# Adjust Column Names
df_charSet = df_charSet.rename({0:"Character", 1: "Dec", 2:"Hex"}, axis='columns')

# Probably not needed
'''
df_charCol = df_charSet.loc[:,['Character']]
df_decCol = df_charSet.loc[:,['Dec']]
df_hexCol = df_charSet.loc[:,['Hex']]
'''
# Build the keyboard walk matrix to hold statistical data for use later
cv = CountVectorizer(ngram_range=(1,2))
walk_cv = cv.fit_transform(stage1)
walk_dtm = pd.DataFrame(walk_cv.toarray(),columns=cv.get_feature_names())