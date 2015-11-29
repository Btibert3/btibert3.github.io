---
layout: post
comments: true   
---


# About this post 

I have been playing with Neo4j quite a bit, mostly for fun as I learn how I figure out when and where I could apply it to solve various analytics problems.  Neo4j, at it's core, is a database, which allows us to query data in a structured way.  While the graph model within Neo4j is very flexible, the `cypher` query language is fantastic.  Once you get over the learning curve, with only a few lines of code you can do some really powerful queries.  

With that said, I have increasingly realized that it's better to move the analytics outside of the database. Even though you can execute `cypher` statements against the database, how and where you execute them will matter once you go beyond "toy datasets."  

This post is to two helpful code snippets that I inject into my workflow when combining `R` and `Neo4j` for my project.

## Snippet 1: Load CSV from within R

First off, I use [RNeo4j](https://github.com/nicolewhite/RNeo4j) to connect R to `Neo4j`.  It is totally possible to load data within dataframes into `Neo4j` using the `?cypher` command; Nicole shows you how to do this in the `Import` section of the README on the project page. But be warned, once you get to larger datasets, this might not be your best option with respect to speed performance.

If you haven't already, play around with the `neo4j-shell` and the `LOAD CSV` functionality.  It's pretty fast and can handle files of a few million records.  

The snippet below is a quick way to simply call that procedure from within your `R` script.

```
NEO_SHELL = "~/neo4j-community-2.3.1/bin/neo4j-shell"
build_import = function(neo_shell, cypher_file) {
  cmd = sprintf("%s -file %s", neo_shell, cypher_file)
  system(cmd)
}
```

Just point to your shell and store it in the variable `NEO_SHELL`.  From calling it is simple.

```
build_import(NEO_SHELL, "../cypher/add-contstraints.cql")
```

I simply reference the shell, and pass a text file that contains my cypher statements.  

From my experiences, there are huge performance gains when using the shell to execute commands, so the helper function above let's me stay within R but benefit from the performance gains.


## Snippet 2:  Read a Cypher query file into `R`

When developing your code, inevitably you will be playing around with the incredibly helpful browser tool.  I use it to prototype my queries, especially before running `LOAD CSV` on a larger file.  

When using R, I have two options.

1.  Type in the cypher query into a string, and then pass the query to the `cypher` function within the R package.  Or,
2.  Development my queries in seperate text files.  I use a `.cql` extension.  To me, it's easier to maintain, but needs to be brought into R.

The process below will bring in a cypher query as a statement into `R` that can be further passed to the cypher function. 

```
## read the cypher query into a string variable  
## http://stackoverflow.com/questions/9068397/import-text-file-as-single-character-string  
FILE = "../cypher/get-edges.cql"
cypher_edges = readChar(FILE,file.info(FILE)$size)

## get the edges
edges = cypher(graph, cypher_edges)
```

Above, I have a query file that I read into the variable `cypher_edges` and pass that to cypher. I use this query to return data back to R.  To me, I would rather manage my queries in seperate files, not within R, and this allows me to do that.  Moreover, I believe it makes organizing your project's structure much easier.

## Aside:  My current workflow

I recently implemented the two helper snippets above when working through a dataset for work.  After trying to load data, and calculate similarities within the datase (a future post), I arrived at this workflow.  Given my tool of choice is `R`, the workflow below is both manageable and pretty fast.

1.  Query my data warehouse for new data  
2.  Use `R` to clean and tidy the data for import into `Neo4j`  
3.  Write the data to CSV files that can be consumed by `LOAD CSV`.  I use Snippet 1 to do that.  
4.  Once the data are in the database, bring back a subgraph of interest into R using Snippet 2.  
5.  Manipulate the data as needed. For example, calculate jaccard similarities across the nodes of interest.  
6.  Write the similarities to another csv file.  
7.  Use Snippet 1 again to write the similarties back into the database for use in other queries.


For one project, in less than 5 minutes, I was able to import two years of applicants, along with various demographics on that pool, calculate the similarity based on interactions, and write those similarties (nearly 2.8 million rows) back to the database.  In terms of speed, this workflow will enable me to opertationalize all sorts of models that can be further implemented into marketing and recruitment efforts.  I will post on this shortly ...


## Summary

This post was meant to capture two helpful code snippets that improve my workflow, and speed, of analyzing datasets in `R` and `Neo4j`.




