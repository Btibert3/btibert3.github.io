## http://www.graphviz.org/Documentation.php
## http://rich-iannone.github.io/DiagrammeR/graphviz.html

grViz("
digraph neo4j {
      
      # a 'graph' statement
      graph [overlap = false, fontsize = 10]
      
      # several 'node' statements
      node [shape = circle, fontname = Helvetica]
      a [label = 'Student']; 
      b [label = '@@1-1'];
      c [label = '@@1-2'];
      d [label = 'SANC'];
      e [label = 'SAHC'];
      
      # several 'edge' statements
      a -> b [label = 'WAS_SENT' fontsize = 9.5];
      b -> c [label = 'NEXT'];
      a -> d [label = 'FROM_CLUSTER'];
      a -> e [label = 'FROM_CLUSTER'];
      }

[1]: rep('Email', 2)
",
engine = "twopi")