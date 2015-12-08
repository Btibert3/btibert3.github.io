---
layout: post
comments: true
---






# Using `DiagrammeR` to help with Data Modeling in Neo4j

I have been watching the [DiagrammeR](http://rich-iannone.github.io/DiagrammeR/index.html) package for a while now, and at this stage, it's pretty impressive.  I encourage you to take a look at what is possible, but be assured the framework is there to do some really awesome things.

One use-case that applies to me is that of data modeling an app within [Neo4j](http://neo4j.com/).  There are already some tools out there, namely:

-  [Arrows](http://www.apcjones.com/arrows/)
-  [Graphgen by GraphAware](http://graphgen.graphaware.com/)
-  [And you can always use graphgists](https://gist.github.com/nawroth/5880880)

The last link above is a sample graph gist that is a decent overview.

In this post, however, I am going to demo the idea that you can use `DiagrammeR` to assist in the data modeling process.  The benefits, in my opinion, are:

-  Reproducibility.  The arrows tool above is a fantastic in-browser solution, but it lends itself to working on 1 model at a time.  And when you want to restore a previous data model, you have to re-build it again through point-and-click.

-  The syntax is pretty expressive.  The package builds on top of [Graphviz](http://www.graphviz.org/).  Read through the documentation.  The syntax is fairly straight forward, but enables you to do some really powerful diagrams, including ERDs for a relational database.

## A Basic Model

The code and data model below are intended to highlight a simple proof-of-concept about how you might leverage graphViz to make the data-modeling tasks in Neo4j easier.


```r
grViz("
      digraph neo4j {
      
      # a 'graph' statement
      graph [overlap = false, fontsize = 10]
      
      # several 'node' statements
      node [shape = circle, fontname = Helvetica]
      a [label = 'Student']; 
      b [label = '@@1-1'];
      c [label = '@@1-2'];
      d [label = '@@1-3'];
      e [label = '@@1-4'];
      f [label = '@@1-5'];
      g [label = 'Marketing Persona'];
      h [label = 'Gender'];
      i [label = 'State'];
      j [label = 'Region'];
      k [label = '@@2-1'];
      l [label = '@@2-2'];
      m [label = '@@2-3'];
      n [label = '@@2-4'];
      
      # several 'edge' statements
      a -> b [label = 'WAS_SENT' fontsize = 9.5];
      b -> c [label = 'NEXT'];
      c -> d [label = 'NEXT'];
      d -> e [label = 'NEXT'];
      e -> f [label = 'NEXT'];
      a -> g [label = 'FROM_PERSONA'];
      a -> h [label = 'HAS_GENDER'];
      a -> i [label = 'LIVES_IN'];
      i -> j [label = 'IS_IN'];
      a -> k [label = 'HAS_INTERACTION' fontsize = 9.5];
      k -> l [label = 'NEXT'];
      l -> m [label = 'NEXT'];
      m -> n [label = 'NEXT'];
      }
      
      [1]: rep('Email', 5)
      [2]: rep('Interaction', 4)
      ",
engine = "circo")
```

![example](https://dl.dropboxusercontent.com/u/15276022/blog-images/diagrammer-testing/diagrammer-testing.png)

From above, a few things that I wanted to call out:

-  My example is graph is very specific to Enrollment Management.  In this case, the data are very student-centric, in that a Student is sent marketing emails, has various demographics associated with them, and interacts with you in a variety of ways (i.e. visit campus, request's information, etc.).  Your domains might yield "prettier" graphs.
-  I am leveraging the `@@` option to dynamically build the labels, which you reference at the end of the script through a footnote.  
-  You can control a large number of elements.  In a couple of cases, I manually specifiy the fontsize for the edge label.


## Summary

By no means is this a robust demonstration, but simply a quick post to demonstrate an option that you might want to leverage when documenting and building out your database.  As mentioned above, the fact that you can reproduce your graph is why I will probably use `DiagrammeR` to work through my data modeling tasks.
