---
layout: post
comments: true
---




# Playing Around with the Prismatic Topic Graph API using R

The Prismatic Team has slowly been rolling out a very cool API.  You can read all about it [here](https://github.com/Prismatic/interest-graph).  At the same time, I have been using this as an opportunity to learn how to create an R package.  

After today's API update to identify the relevant content related to a specific topic, I wanted to highlight what is possible with a few lines of code using the `prismaticR` package.  Needless to say, my package is raw, but I wanted to highlight some of the cool things that you can do with Prismatic's API.  

## Let's get started

First things first, you can use `devtools` to install the `prismaticR` package.  


```r
## install devtools package -- uncomment line below if you need to install
# install.packages("devtools")
# library(devtools)

## install my prismaticR package if you havent already
# install_github("btibert3/prismaticR")

## now lets load it
# library(prismaticR)
```


Before you move forward, you will need to get an API token for your calls.  [You can get that token here](http://interest-graph.getprismatic.com/).

Store your token in an object called TOKEN ...


```r
TOKEN = "YOUR_TOKEN_HERE"
```




## Explore the API

The first thing that we should do is crawl the topic id database.  We will use this later ...


```r
tids = prizTID()
```

```
Error in GenericTranslator$new: could not find function "loadMethod"
```

```r
## keep everything lower case 
tids$topic = tolower(tids$topic)
```

```
Error in tolower(tids$topic): object 'tids' not found
```

We can use the `stringr` package to filter topic names based on keywords of interest.  For example, how many of the topics include the term `admission`   


```r
tids[str_detect(tids$topic, "admission"),]
```

```
Error in eval(expr, envir, enclos): object 'tids' not found
```

A broader keyword ...


```r
tids[str_detect(tids$topic, "higher ed"),]
```

```
Error in eval(expr, envir, enclos): object 'tids' not found
```

How about college?


```r
head(tids[str_detect(tids$topic, "college"),], 10)
```

```
Error in head(tids[str_detect(tids$topic, "college"), ], 10): object 'tids' not found
```

And university? ..


```r
head(tids[str_detect(tids$topic, "university"),], 10)
```

```
Error in head(tids[str_detect(tids$topic, "university"), ], 10): object 'tids' not found
```

And to close it out, how about student ... 


```r
tids[str_detect(tids$topic, "student"),]
```

```
Error in eval(expr, envir, enclos): object 'tids' not found
```

This might be a good time to use the similar topic API.  To keep it simple, let's identify the topics that are related to the topic of `Harvard University` ...


```r
harvard = tids[str_detect(tids$topic, "harvard uni"),]$id
```

```
Error in eval(expr, envir, enclos): object 'tids' not found
```

```r
prizSIM(TOKEN, TID = harvard)
```

```
Error in prizSIM(TOKEN, TID = harvard): object 'harvard' not found
```

Interesting.  How about `Amherst College`? ...


```r
prizSIM(TOKEN, TID = 182)
```

```
  topic_id            topic   score
1     4866 Williams College 0.32472
```

The API even allows to identify the __current stories__ relevant to `college admissions`?  The top 5 are ...





```
    score                                                                                                url
1 0.66227          http://now.dartmouth.edu/2015/03/2120-students-offered-acceptance-into-the-class-of-2019/
2 0.64772          http://college.usatoday.com/2015/03/31/i-didnt-get-into-my-first-choice-college-now-what/
3 0.64290        http://www.huffingtonpost.com/2015/03/31/siobhan-odell-duke-rejection-letter_n_6977048.html
4 0.62981                                              http://dailyprincetonian.com/news/2015/03/admissions/
5 0.62837 http://www.nj.com/mercer/index.ssf/2015/03/princeton_university_has_most_selective_admissions.html
```


And for the sake of bots, here is the title of the "hottest" page above ...


```r
x_resp = html(x$url[1])
html_node(x_resp, "title") %>% html_text()
```

```
Error in GenericTranslator$new: could not find function "loadMethod"
```


## Summary  

Have fun. I make no warantees for the R package, but with a few calls, you can do some really cool things.
