---
layout: post
comments: true   
---

___This is a resposting of a gist from 12/3/2013 that I searched high and low for recently.  Why not re-post?___

# Environment Variables in Rstudio on Mac

I recently asked a question on [Stack Overflow](http://stackoverflow.com/questions/34160664/environment-variables-in-rstudio-on-mac) on the best way to set environment variables on a Mac for use within an RStudio session.  

It wasn't as straightforward as I would have thought, so I wanted to share this quick post as a way to remind my future self of a quick way to solve the issue.

## Overview

Generally, you can set environment variables by:

```sh
export YOUR_VAR=abc123
```

within a terminal.  In a new session, 

```sh
echo $YOUR_VAR
``` 
should yield what you need.

Within python, you can get at it by:

```
import os
os.getenv("YOUR_VAR")
```
but if you are using `R` and `Rstudio`, `Sys.getenv("YOUR_VAR")` will return `""`.

No bueno.  


## A solution

Navigate to `~`, and create the `.Renviron` file if it doesn't already exist

```sh
cd ~
touch .Renviron
open .Renviron
```

And in the file, type

```
YOUR_VAR="abc123"
```

Save the file and restart/reopen Rstudio.  

From there, `Sys.getenv("YOUR_VAR")` should be good to go.


## Deeper Dive

For a more granular look at this functionality, feel free to reference the links below

-  [Startup](https://stat.ethz.ch/R-manual/R-devel/library/base/html/Startup.html)
-  [The reference that I used](https://www.biostat.wisc.edu/~kbroman/Rintro/)


