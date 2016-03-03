---
layout: post
---

Below is a quick writeup on how I use `R` and `RNeo4j` to munge my data and throw "larger" datasets into Neo4j.  In short, I am fairly capable in R, so I prefer to use it to do the heavy lifting.  

All I am doing is calling the `neo4j-shell` tool via `?system` command. This post runs through how I have used this approach in some of my recent projects.  I used this process for a project that I am currently working on at work, where 3+ million nodes and nearly 9 million relationships.  

## Basic project structure  

Below is a basic project structure when I am combining R and `Neo4j`

```
neo-project/
├── R
│   ├── 1-get-data.R
│   ├── 2-clean-data.R
│   └── 3-import-data.R
├── README.md
├── cql
│   ├── constraints.cql
│   └── import-nodes.cql
└── data
    ├── file1.csv
    └── file2.csv

3 directories, 8 files
```

There are many ways to organize projects, but I recommend that you stick with one that works for you. 

## General Process

1.  Collect, clean, build out my datasets using R  
2.  Save the datasets as `csv` files
3.  Import the data into Neo4j via R and `neo4j-shell` 

On the third step above, I am using a helper function, shown below.

## Helper Function

```
### helper function to load a CQL file into neo4j shell
build_import = function(neo_shell = "~/neo4j-community-2.3.1/bin/neo4j-shell", 
                        cypher_file) {
  cmd = sprintf("%s -file %s", neo_shell, cypher_file)
  system(cmd)
}
```

In my case, I am simply running a community edition, and point to the path of the `neo4j-shell` tool.  If you get an error, you may need to ensure that:

1.  The database is running  
2.  You are pointed to the proper location for the shell tool

After that, usage is simple within your R script.

```
build_import(cypher_file = "../cql/import-geo.cql")
```

The `RNeo4j` package is great, and in particular, I love the `?clear` function which helps us rapidly prototype our data imports, the data model, etc.


## Example Session  

Below is an example session of what the R script `3-import-data.R` might look like.

```
###############################################################################
## Load the csvs through Cypher and the terminal 
## in a non-Windows environment
###############################################################################

options(stringsAsFactors = FALSE)

## the packages
library(RNeo4j)

## connect to a running db server
graph = startGraph("http://localhost:7474/db/data/",
                   username = "neo4j",
                   password = "password")


###############################################################################
## helper function
###############################################################################

## cypher helper function to load against the shell tool
build_import = function(neo_shell = "~/neo4j-community-2.3.1/bin/neo4j-shell", 
                        cypher_file) {
  cmd = sprintf("%s -file %s", neo_shell, cypher_file)
  system(cmd)
}


###############################################################################
## clear database for testing
###############################################################################

## clear the entire database
clear(graph, input = FALSE)

###############################################################################
## load daata - 1 file per import
###############################################################################

build_import(cypher_file = "../cql/constraints.cql")
build_import(cypher_file = "../cql/import-nodes.cql")

```
