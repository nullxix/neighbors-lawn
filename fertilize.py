#!/usr/bin/env python3
import local_agrostologist

filebox = local_agrostologist.get().latest().research(2)

for study in filebox:
    f = open('./dump/' + study['filename'], 'w')
    f.write(study['contents'])

print('Yay! It worked')



import random
