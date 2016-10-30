---
layout: post
---

# Python, Rodeo, and Tableau Data Extract API

Many moons ago, I wrote some code to build a Tableau Data Extract from the data I had munged together in `python`.  I figured it was time to update the code since I recently discovered that the Tableau API has changed.

For a link to that old code, refer to the Jupyter Notebook in this [repo](https://github.com/Btibert3/tableau-r).

## Assumptions and Requirements

First off, I am using a Macbook, and while I believe things are getting easier on Windows machines with respect to coding, I prefer to write Terminal commands over point-and-click installs.

For tools, we will be using:

- A light-weight python instance from Anaconda called [Miniconda](http://conda.pydata.org/miniconda.html).  This lets us create environments that house the versions of the packages that we need, and it just works.  Installation should be easy and is well documented on their site.  The beauty of `conda` is that the tool handles all of the version dependencies for us!  Prior, getting packages to work could be a nightmare at times.

- [The Tableau Python SDK](https://onlinehelp.tableau.com/current/api/sdk/en-us/help.htm#SDK/tableau_sdk_using_python.htm%3FTocPath%3D_____4).  This was surprisingly harder to find than I would have guessed.  Simply download the SDK, unpack it, and follow the instructions at the link.  We will do this below, however.

- While not necessary, I am going to use [Yhat's Rodeo](https://www.yhat.com/products/rodeo) IDE and list how to configure the editor to use a specific conda environment.  This is also easy to install, and assumes that you have already done so.

- Tableau, of course.  


## 1.  Create our Python environment

Assuming you have miniconda installed properly, we are going to create a Python 2.7 environment for our work with the Tableau API.

First, let's explore what I have for environments on my system.

```
$ conda info --envs
```

yields

```
# conda environments:
#
chatbot                  /Users/btibert/miniconda3/envs/chatbot
ipy                      /Users/btibert/miniconda3/envs/ipy
tableau                  /Users/btibert/miniconda3/envs/tableau
root                  *  /Users/btibert/miniconda3
```

Above are the environments that I have set up on my machine.  If you are not familiar with environments, think of them as isolated installs of python with various packages for your use-case.  Environments are a great way to isolate the versions and dependencies relative to a project, and allows you to avoid collisions if you just manage a single python environment.

Now, lets create our environment.  In this case, I am going to call it `tableau-post`.  

```
conda create -n tableau-post python=2.7 pandas jupyter matplotlib
```

This will install `python 2.7  `, `pandas`, `matplotlib` and `jupyter` (formerly ipython).  

These packages and version are what you need to:

- Run Rodeo
- Use the Tableau Data Extract API

To activate the environment, simply use:  

 ```
 source activate tableau-post
 ```

 The code above will activate our environment.

 To confirm that you are good to go:

 ```
source activate tableau-post
which python
 ```   

 In my case, this yields:

 ```
/Users/btibert/miniconda3/envs/tableau-post/bin/python
 ```

 __We will use this when we configure Rodeo later on.__  

From this point forward, I am going to assume that you have `tableau-post` activated.

## 2.  Get the Tableau SDK

The code below jumps into `Downloads` and will get the Tableau SDK from the web.

```
cd ~/Downloads/
wget https://downloads.tableau.com/tssoftware/Tableau-SDK-Python-OSX-64Bit-10-0-2.tar.gz
tar -xvzf Tableau-SDK-Python-OSX-64Bit-10-0-2.tar.gz
```

This will download and unpack the file, which will yields a directory that we need for installation.  

```
cd TableauSDK-10000.16.1004.1720/
```

The command above will navigate into the folder.

```
sudo python setyp.py install
```

The command above will install the Tableau SDK for you.  For more on this, go to [this link](https://onlinehelp.tableau.com/current/api/sdk/en-us/help.htm#SDK/tableau_sdk_using_python.htm%3FTocPath%3D_____4)

## 3.  Fire up Rodeo and Configure it

With Rodeo open, navigate to `Preferences`.  You will see a dialog box similar to the one below.

![preferences](https://github.com/Btibert3/public-figs/blob/master/Rodeo-Tableau-API/Rodeo-Preferences-Conda-Env.png?raw=true)

You can see above that for the __Python Command__ I am using the same location that was printed from  the `which python` command within the `tableau-post` environment.  

It's that simple; now you can use isolated environments when developing with Rodeo!

The majority of the code that I write is in `R` using the fantastic [Rstudio IDE](https://www.rstudio.com/products/rstudio/), and while the Rodeo tool is not as feature-rich (yet), it's great for the way I develop.  The fact that there is "type-ahead" functionality (read: you write less code), and the ability to commit the lines of my script 1x1, is extremely helpful for the way I work through my tasks.  

I hardly debug in an efficient way, but I also tend to solve smaller problems and do not require test suites.

## 4.  Build a Basic Extract

Below are a few helpful resources on how to use python to build out a Tableau Data Extract:

- [Tableau Community Post](https://community.tableau.com/message/529982)
- [Building Tableau Data Extract files with Pythin in Tableau 8](http://ryrobes.com/python/building-tableau-data-extract-files-with-python-in-tableau-8-sample-usage/)
- [My old notebook](https://github.com/Btibert3/tableau-r/blob/master/Python-R-Tableau-Predictive-Modeling.ipynb)
- [Build Extracts out of CSVs](http://ryrobes.com/python/build-tableau-data-extracts-out-of-csv-files-more-python-tde-api-madness/)

The code below builds out a basic extract from a sample dataset available on the web.

```
## import the libraries
import tableausdk.Extract as tde
import pandas as pd
import os

## bring in a sample Graduate School Admissions datasets
file_name = "http://www.ats.ucla.edu/stat/data/binary.csv"
df = pd.read_csv(file_name)
df.head()
df.shape

## create the extract name, but remove the extract if it already exists
fname = "example.tde"
try:  
    tdefile = tde.Extract(fname)
except:
    os.system('del ' + fname)
    os.system('del DataExtract.log')
    tdefile = tde.Extract(fname)


# define the table definition
tableDef = tde.TableDefinition()

# create a list of column names and types
colnames = df.columns
coltypes = df.dtypes

# create a dict for the field maps
# Caveat: I am not including all of the possibilities below
fieldMap = {
    'float64' :     tde.Types.Type.DOUBLE,
    'float32' :     tde.Types.Type.DOUBLE,
    'int64' :       tde.Types.Type.DOUBLE,
    'int32' :       tde.Types.Type.DOUBLE,
    'object':       tde.Types.Type.DOUBLE,
    'bool' :        tde.Types.Type.DOUBLE
}

# for each column, add the appropriate info the Table Definition
for i in range(0, len(colnames)):
    cname = colnames[i]
    ctype = fieldMap.get(str(coltypes[i]))
    tableDef.addColumn(cname, ctype)  


# create the extract from the Table Definition
# Super Hacky, but legible
# for each row, add the data to the table
# Again, not accounting for every type or errors
with tdefile as extract:
    table = extract.addTable("Extract", tableDef)
    for r in range(0, df.shape[0]):
        row = tde.Row(tableDef)
        for c in range(0, len(coltypes)):
            if str(coltypes[c]) == 'float64':
                row.setDouble(c, df.iloc[r,c])
            elif str(coltypes[c]) == 'float32':
                row.setDouble(c, df.iloc[r,c])
            elif str(coltypes[c]) == 'int64':
                row.setDouble(c, df.iloc[r,c])   
            elif str(coltypes[c]) == 'int32':
                row.setDouble(c, df.iloc[r,c])
            elif str(coltypes[c]) == 'object':
                row.setString(c, df.iloc[r,c])
            elif str(coltypes[c]) == 'bool':
                row.setBoolean(c, df.iloc[r,c])
            else:
                row.setNull(c)
        # insert the row
        table.insert(row)

## close the file
tdefile.close()
```

## Summary

Some notes on the process:

-  I am attempting to build-in some "smarts" as to how you define the column types by using the pandas data type and mapping that to a Tableau data type.
-  The process defines the table, and for each row, and each column in that row, loops through the data 1x1 to define each value, and then commits the data to the row.  __NOT ALL TYPES ARE BEING ACCOUNTED FOR__
-  Each row is being processed in a serial fashion, so this might take some time depending on the size of your dataset.

I hope that this helps you as you develop with Python and Tableau.  I recently have been trying to define a workflow locally to prototype my data needs, and since my dataset has millions of rows, using CSVs and local database tables just isn't cutting it.
