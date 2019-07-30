#!/usr/bin/env python
# coding: utf-8

# In[2]:


import os
os.chdir('C:\\Users\\adamg\\Documents\\GitHub\\HCAHPS_hospital_outcomes\\Python\\Data Import and clean'
        )


# In[ ]:


# %load hcahps_import_clean.py
#!/usr/bin/env python

import os
os.chdir('C:\\Users\\adamg\\Documents\\Medical Research data\\'
    'Data Models\\Patient Experience\\Data_Imports')


# Import HCAHPS linear survey data summarized at hospital level
# Publisher	Centers for Medicare & Medicaid Services
# Download using json and archive data as csv

import pandas as pd

url = ('https://data.medicare.gov/resource/rmgi-5fhi.json?$limit=500000')
pd.read_json(url, orient='records')

hcahpsdt = pd.read_json(url, orient='records')

hcahpsdt.to_csv('HCAHPS_linear_survey_summary_data_07192019.csv', header=True)

# Confirm integrity of primary key colum 'provider_id'
hcahpsdt.index

# Confirm row count match expected count located on Data.Medicare.gov:  chrome-extension://klbibkeccnjlkjkiokjodocebajanakg/suspended.html#ttl=Patient%20survey%20(HCAHPS)%20-%20Hospital%20%7C%20Data.Medicare.gov&pos=692.7999877929688&uri=https://data.medicare.gov/Hospital-Compare/Patient-survey-HCAHPS-Hospital/dgck-syfz

# Set erc to expected row count

erc = 245450
rc = len(hcahpsdt.index)

if erc < rc:
    print('Actual row count greater than expected by: ' + str(rc - erc) + ' row(s)')
elif erc > rc:
    print('Missing ' + str(erc - rc)+ ' rows')
elif erc == rc:
    print('Row counts match!')
else:
    print('Expected to actual row comparison not working')


# Check actual column count vs expected using shape opperator to save on memory

#Set ecc to expected column count

ecc= 29

acc = hcahpsdt.shape[1]

if ecc < acc:
    print('Actual column count greater than expected by: ' + str(acc - ecc) + ' column(s)')
elif ecc > acc:
    print('Missing ' + str(ecc - acc)+ ' columns')
elif ecc == acc:
    print('Column counts match!')
else:
    print('Expected to actual column comparison not working')


# Evaluate data types
hcahpsdt.dtypes

# Notes: 
#   hcahps_linear_mean_value is not int, investigate missing or char values in column

hcahpsdt.head(100)

# Null valuesin linear mean variables will be handled in BI tool

