#!/usr/bin/env python
# coding: utf-8

# In[ ]:


#Load py file from Git
import os
os.chdir('C:\\Users\\adamg\\Documents\\GitHub\\HCAHPS_hospital_outcomes\\Python\\Data Import and clean'
        )

# %hospital readmission data import and clean.py
#!/usr/bin/env python


# In[2]:


import os
os.chdir('C:\\Users\\adamg\\Documents\\Medical Research data\\'
    'Data Models\\Patient Experience\\Data_Imports')


# In[17]:


# Import Hospital Readmissions Reduction Program data, 
# In October 2012, CMS began reducing Medicare payments for Inpatient Prospective Payment System hospitals with excess readmissions. Excess readmissions are measured by a ratio, calculated by dividing a hospital’s number of “predicted” 30-day readmissions for heart attack (AMI), heart failure (HF), pneumonia, chronic obstructive pulmonary disease (COPD), hip/knee replacement (THA/TKA), and coronary artery bypass graft surgery (CABG) by the number that would be “expected,” based on an average hospital with similar patients.
# Download using json and archive data as csv

import pandas as pd

url = ('https://data.medicare.gov/resource/kac9-a9fp.json?$limit=500000')


# In[18]:


pd.read_json(url, orient='records')


# In[19]:


# Confirm integrity of primary key colum 'provider_id'
hrrp= pd.read_json(url, orient='records')
hrrp.index


# In[20]:


# Confirm row count match expected count located on Data.Medicare.gov:19,674
# Set erc to expected row count

erc = 19674
rc = len(hrrp.index)

if erc < rc:
    print('Actual row count greater than expected by: ' + str(rc - erc) + ' row(s)')
elif erc > rc:
    print('Missing ' + str(erc - rc)+ ' rows')
elif erc == rc:
    print('Row counts match!')
else:
    print('Expected to actual row comparison not working')


# In[21]:


# Check actual column count vs expected using shape opperator to save on memory

#Set ecc to expected column count

ecc= 12

acc = hrrp.shape[1]

if ecc < acc:
    print('Actual column count greater than expected by: ' + str(acc - ecc) + ' column(s)')
elif ecc > acc:
    print('Missing ' + str(ecc - acc)+ ' columns')
elif ecc == acc:
    print('Column counts match!')
else:
    print('Expected to actual column comparison not working')


# In[22]:


# Evaluate data types
hrrp.dtypes

#Note: expecting int64 for readmin ratio / rate, assume null values caused object format


# In[23]:


hrrp.head(100)

#Notes: Data align with expected columns, null values force int to object formatting


# In[24]:


# Save to csv file
hrrp.to_csv('hrrp_summary_data_07302019.csv', header=True)


