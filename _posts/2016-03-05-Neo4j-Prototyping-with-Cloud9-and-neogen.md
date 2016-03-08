---
layout: post
---

# Prototype Neo4j Development with Cloud9 and the Graphgen Tool

If you have skimmed through some of my other posts on this blog, it's probably not surprising that I love using Neo4j in my projects.  While you certainly can develop and work through your ideas locally, if you are like me, you probably have a few pet projects going at once, some of which you might want to share publicly.  

This post aims to highlight how quickly you can get up and running using [Cloud9](https://c9.io/?redirect=0), a cloud-based development environment.  There are other Neo4j-hosting solutions that you might want to look at, but since Cloud9 recently upgraded their instances to have 1 gig of memory and 5gb of disk space, I wanted to highlight that there are other options available. 

In future posts, I will talk about my work on using Neo4j to highlight how we can get smarter in higher education marketing and student recruitment.  Because I obviously can't show my institution's data publicly, I am also going to demonstrate how we can use the [neogen](https://github.com/graphaware/graphgen) tool to simulate a real dataset and populate our database.  It's a really awesome tool that I will talk more about in a moment.

## What you need 

To follow along in this post, you don't need much.  In truth, all you really need to have is a Cloud9 account and an internet connection.  I won't go into how to create an account, but in my case, I simply sign in using my Github account.  It probably can't get much easier than that!

## Getting Started

Once you are logged into Cloud9, spin up a new workspace. Below is the setup screen that you will most likely see.  

![](https://dl.dropboxusercontent.com/u/15276022/blog-images/neo4j-cloud9/image-1.png)

Above, I am creating a public Cloud9 instance, and will be using the Custom template, but you can see that there are other pre-configured options available.  

> As an aside, it would be great if they added more templates.  Selfishly, I would love to see a R/Rstudio Server template, and perhaps a Flask/postgres template.  Maybe one day .... 

When you are ready, spin up the instance.  You will probably see an image like below as the server is being set up.

![](https://dl.dropboxusercontent.com/u/15276022/blog-images/neo4j-cloud9/image-2.png)

That might take a few moments, and when it has completed, you will have your own workspace in the cloud, accessible via the browser.  You should see something similar to the screen below.  

![](https://dl.dropboxusercontent.com/u/15276022/blog-images/neo4j-cloud9/image-3.png)

On the left-hand side, we have a file tree, on the top is our text editor, and at the bottom, a terminal.  The workspace is totally customizable, so poke around and configure the environment to your liking.

At this stage, we are ready to install Neo4j and graphgen.

## Get the neogen Repo from Github

Now we want to clone the neogen repo, which will allow us to write `cypher` to generate fake data and populate our Neo4j database.  It's a really powerful tool.  We can prototype our data model and build-out real-life datasets to work through how we might solve a problem, without actually using real data. This is great when the data can not be distributed publicly or you are prototyping a solution and the data do not yet exist.

Cloud9 already has `git` setup, so it's a simple command to clone the tool into our workspace.

```
git clone https://github.com/neoxygen/neo4j-neogen.git
```

This should put the repo in your home directory.  

```
btibert3:~/workspace $ ls -l
total 8
-rw-rw-r-- 1 ubuntu ubuntu  699 Sep 24 12:24 README.md
drwxr-xr-x 8 ubuntu ubuntu 4096 Mar  5 00:14 neo4j-neogen/
```

If you type `ls -l neo4j-neogen` you should see a number of files.  If you do, you should be (almost) good to go.

## Install Neo4j

Now we will download the community version of neo4j 2.3.1  

```
wget "http://neo4j.com/artifact.php?name=neo4j-community-2.3.2-unix.tar.gz"
```  

And unpack it  

```
tar -xf artifact.php\?name\=neo4j-community-2.3.2-unix.tar.gz 
```

I like clean workspaces, so I am going to remove the original file.

```
rm artifact.php\?name\=neo4j-community-2.3.2-unix.tar.gz
```

## Review

This is what I now have in my workspace.  

```
total 12
-rw-rw-r-- 1 ubuntu ubuntu  699 Sep 24 12:24 README.md
drwxr-xr-x 8 ubuntu ubuntu 4096 Jan 12 23:01 neo4j-community-2.3.2/
drwxr-xr-x 8 ubuntu ubuntu 4096 Mar  5 00:14 neo4j-neogen/
```

## Neo4j Configuration for Cloud9

One of the many awesome features of Neo4j is the power of it's browser tool, which I want to be able to access for my running database on Cloud9.  As of this writing, Cloud9 only opens ports `8080, 8081, and 8082` via this [page](https://docs.c9.io/docs/run-an-application), so we will need to modify some of Neo4j's default options.  

> One of the many reasons that I like working in cloud-based IDE's like Cloud9 is that I can edit the text files on my cloud server via the browser.  I know that it's cool to use `vim` and `vi` when working with remote files, but those tools just get in my way at my current skill level.  If I can use text editor in my browser (or locally), I will choose that option 100% of the time.  

Using the in-browser IDE, navigate to the `neo4j-server.properties` file located in the `/conf` directory. If you double-click the file in the left-hand pane, you will open it within Cloud9's text editor.  For example, your browser should look similar after navigating and opening the file.  

![](https://dl.dropboxusercontent.com/u/15276022/blog-images/neo4j-cloud9/image-4.png)

In the file above, we are going to make 3 changes:

#### 1. Open the server to the public, not just the localhost
By default, this line is commented out.  All that you need to do remove the `#` in front of `org.neo4j.server.webserver.address=0.0.0.0`.  

#### 2. Disable security. Yes, disable.  

Obviously you should almost never do this, but for this exercise, I am just highlighting that you can.  Because this is just a tutorial and no real data are being used, security isn't needed.  **But needless to say, please be careful when you change this setting in your own projects.**

Currently you should see the following setting in the file: 

```
dbms.security.auth_enabled=true
```
Set `true` to `false`.

#### 3. Change the port so cloud9 will serve it.  

As mentioned above, Cloud9 only opens a few ports.  Let's change the Neo4j's default port from `7474` to `8080`.

**After saving the file**, below shows the 3 settings that were modified:

![](https://dl.dropboxusercontent.com/u/15276022/blog-images/neo4j-cloud9/image-5.png)

## Fire up the database server

Now all that we need to do is start Neo4j.  In the terminal navigate to the directory that houses the database files.  In my case, the prompt reads:  `btibert3:~/workspace/neo4j-community-2.3.2 $ `.  

Now, we start the server with a simple command.  

```
bin/neo4j start
```

It might take a few seconds, but you should be good to go.  As a point of reference, there are a few commands that you will find helpful as you work through your projects.  

```
bin/neo4j start
bin/neo4j stop
bin/neo4j restart
bin/neo4j status
```

With the changes above, we can access Neo4j's browser tool for this running database.  

Generally speaking Cloud9 allows you to access your applications in your project workspace via the following naming convention.

```
<project>-<user>.c9users.io:port/
```

In my case, I can access the browser tool for my project by opening up a new browser tab and navigating to:

```
http://neo4j-graphgen-demo-btibert3.c9users.io:8080/browser/
```

But it's also worth noting that after Neo4j finishes the startup process, the terminal will print that the database is running on `localhost:8080`.  Within Cloud9, if you click on `localhost:8080`, it will bring up the browser tool in a new window; you won't need to type out the path above.


## Use graphgen to prototype ideas

Now that we have a Neo4j instance running, we can leverage the neogen tool to build out our model and dataset.  There are a few ways to leverage the tool, but I am going to focus on the approach the works for my needs. I encourage you to explore the documentation and related projects.   

In a new terminal instance (click the "+" sign in within Cloud9), navigate into the neogen tool we installed a few moments ago.  

```
cd neo4j-neogen/  
```

We need to checkout a specific tag within the git project we cloned earlier.

```
git checkout tags/0.5.11
```

In my case, this is what I see in my terminal

```
btibert3:~/workspace/neo4j-neogen ((0.5.11)) $ ls -l
total 100
-rw-r--r--  1 ubuntu ubuntu  1063 Mar  5 00:14 LICENSE
-rw-r--r--  1 ubuntu ubuntu  3418 Mar  5 00:14 README.md
drwxr-xr-x  2 ubuntu ubuntu  4096 Mar  5 00:14 bin/
-rw-r--r--  1 ubuntu ubuntu   390 Mar  5 00:14 box.json
-rw-r--r--  1 ubuntu ubuntu  1136 Mar  5 01:42 composer.json
-rw-r--r--  1 ubuntu ubuntu 64237 Mar  5 01:42 composer.lock
-rw-r--r--  1 ubuntu ubuntu   784 Mar  5 00:14 phpunit.xml
drwxr-xr-x 13 ubuntu ubuntu  4096 Mar  5 01:42 src/
-rw-r--r--  1 ubuntu ubuntu  2117 Mar  5 01:42 test.php
drwxr-xr-x  3 ubuntu ubuntu  4096 Mar  5 01:42 tests/
```

> At this point I wanted to give a huge shout out and thanks to Christophe Willemsen for developing the neogen tool and working through some of my initial setup issues.  The large reason I wanted to write this post was to share the knowledge that I gained and help those who may also want to leverage Christophe's tool.  If you use neo4j and are following along on the slack channels, you are really missing out!

Finally, you  will probably need to setup the php scripting environment.

```
curl -s http://getcomposer.org/installer | php
```  

and then  

```
php composer.phar install
```

Now, we should have everything that we need to populate our database.  

##### 1.  Create a file to hold the basic commands  

Within the neogen directory, I am simply going to type the command below to create an empty `cql` file which will hold the `cypher` commands that neogen will use to parse and build our database.

```
touch basic-db.cql
```

##### 2. Populate the file

Open up the the `basic-db.cql` file that we just created from the file tree, and in the text editor, paste the `cypher` below and save the file.

```
(stud:Student {sex: {randomElement:['M','F'] },
	          email: safeEmail,
	          userid: uuid,
	          state: stateAbbr,
	          add_date: {unixTime: ["now"]} } *35)
```

The neogen tool leverages the `faker` `PHP` library found [here](https://github.com/fzaninotto/Faker#fakerprovideren_usperson).  There are a host of commands that we can use to simulate all sorts of data elements. As a heavy R user, the [wakefield](https://github.com/trinker/wakefield) is really great and provides similar functionality, but the `faker` library is very impressive in terms of what's possible.

Last but not least, we want to run the command to seed our running database with data.  The important takeaway is that we want to specify the location, **and port** of a running database.  Neogen will handle the rest.


```
./bin/neogen generate-cypher --export-db=localhost:8080 --source=build-db.cql
```

The command should print out 

```
btibert3:~/workspace/neo4j-neogen ((0.5.11)) $ ./bin/neogen generate-cypher --export-db=localhost:8080 --source=build-db.cql
Locating fixtures file
Created 1 constraint(s)
Created 35 node(s)
Created 0 relationship(s)
Graph generation done in 0.85389590263367 seconds
```


And in our browser, we will be able to see the data!


![](https://dl.dropboxusercontent.com/u/15276022/blog-images/neo4j-cloud9/image-6.png)


## Summary

In short, the aim was to highlight the steps necessary to build out a quick, free, development environment for Neo4j using Cloud9.  Hopefully you found this helpful. If you have any questions, feel free to shoot me a comment below and I will do my best to help you out.






