#!/usr/bin/env python
# coding: utf-8

# In[55]:


# Database stuff
from google.cloud.sql.connector import Connector
import sqlalchemy
from getpass import getpass
import pg8000
import google.auth as auth


import pandas as pd


# In[56]:


# Load our credentials from the supplied service account key file
creds = auth.load_credentials_from_file('useful-music-251918-b8ecc9855a02.json')
# Credentials are retrieved as a tuple object with credential object and project name
creds[0]


# In[75]:


# Use getpass to get the database password
password = getpass('Enter Password')

# build connection
# Connector is a Google object that manages the creation of our connector string
def get_conn() -> pg8000.native.Connection:
    with Connector(credentials=creds[0]) as connector:
        conn = connector.connect(
            # Project name:region:database name
            "useful-music-251918:us-central1:project-db",
            # Driver
            "pg8000",
            user="postgres",
            password=password,
            db="postgres"
        )
    return conn

# create connection pool
pool = sqlalchemy.create_engine(
    "postgresql+pg8000://",
    creator=get_conn,
    echo_pool='debug',
    echo=True,
)


# In[67]:


pool


# In[71]:


# Create an iterator to break up the flows data into chunks
pseof_df = pd.read_csv('https://jamesliu-databootcamp-bucket.s3.us-east-2.amazonaws.com/pseof_all.csv', chunksize=10000, low_memory=False)
pseof_df


# In[79]:


# Create an iterator to break up the earnings data into chunks
pseoe_df = pd.read_csv('https://jamesliu-databootcamp-bucket.s3.us-east-2.amazonaws.com/pseoe_all.csv', chunksize=10000, low_memory=False)
pseoe_df


# In[78]:


# Take our iterator, table name, and sqlalchemy connection to upload our data
def push_to_db(df_iter, table, conn):
    rows_imported = 0
    for data in df_iter:

        print(f'importing rows {rows_imported} to {rows_imported + len(data)}...\n', end='')
        data.to_sql(name=table, con=conn, if_exists='append', method='multi')
        rows_imported += len(data)

        print(f'Done.')


# In[80]:


push_to_db(df_iter=pseoe_df, table='pseoe', conn=pool)


# In[61]:


push_to_db(df_iter=pseof_df, table='pseof', conn=pool)


# In[ ]:




