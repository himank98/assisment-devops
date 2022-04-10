# Assisment files for DevOps

## Remove the duplicate words.

- The file `double_words_input.txt` contains the some words which are duplicate and should be removed when they are consecutive.

~~~
double double toil and trouble 

fire burn and cauldron bubble bubble 

tomorrow and tomorrow and tomorrow 

creeps in this this petty pace from day toto day 

to the last syllable of recorded time time
~~~

- To remove this words occurence we need to run the script as follows.

~~~
./double_words.sh double_words_input.txt
~~~

- The following output is observed after running the above script.

~~~
double toil and trouble

fire burn and cauldron bubble

tomorrow and tomorrow and tomorrow

creeps in this petty pace from day toto day

to the last syllable of recorded time
~~~

## Analyse the es data from /_cat/shards api

- The data of /_cat/shards api is collected in a file es_shards_input.txt

~~~
100ms 0 p STARTED    3014 31.1mb 192.168.56.10 H5dfFeA 

100ms 0 r UNASSIGNED 

meta 1 r STARTED    3014 31.1gb 192.168.56.20 I8hydUG
~~~

- To analyse the data run the following script as follows:

~~~
./es_shards.sh es_shards_input.txt
~~~

- The following output is observerd after running the script.

~~~
count: [primary: 1, replica: 2]

size: [primary: 31.1M, replica: 31.1G]

disk-max-node: I8hydUG

watermark-breached: []
~~~