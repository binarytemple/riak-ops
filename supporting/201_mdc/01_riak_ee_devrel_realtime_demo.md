## Riak EE (devrel) Realtime Demo

###Scenario

Using a devrel, configure Riak EE to perform multi-datacenter replication, given the following two (2) local three-node Riak EE Clusters: 

####Cluster 1 

<table>
<tr><th>name</th><th>ip</th><th>cm port</th><th>nodename</th></tr>
<tr><td>node1</td><td>127.0.0.1</td><td>10016</td><td>dev1@127.0.0.1</td></tr>
<tr><td>node2</td><td>127.0.0.1</td><td>10026</td><td>dev2@127.0.0.1</td></tr>
<tr><td>node3</td><td>127.0.0.1</td><td>10036</td><td>dev3@127.0.0.1</td></tr>
</table>

####Cluster 2

<table>
<tr><th>name</th><th>ip</th><th>cm port</th><th>nodename</th></tr>
<tr><td>node4</td><td>127.0.0.1</td><td>10046</td><td>dev4@127.0.0.1</td></tr>
<tr><td>node5</td><td>127.0.0.1</td><td>10056</td><td>dev5@127.0.0.1</td></tr>
<tr><td>node6</td><td>127.0.0.1</td><td>10066</td><td>dev6@127.0.0.1</td></tr>
</table>

> NOTE: The addresses used in the example clusters are contrived, non-routable addresses; however, in real world applications these addresses would need to be routable over the public Internet.

##Set up Cluster1 → Cluster2 replication

###Set up the Source on Cluster1

On a node in Cluster1, `node1` for example, initiate and name this cluster with `riak-repl clustername 
<name>` 

	riak-repl clustername Cluster1
	
###Setup the Sink on Cluster2

On a node in Cluster2, `node4` for example, initiation and name this cluster with `riak-repl clustername <name>`

	riak-repl clustername Cluster2
	
###Connect the Source to the Sink

On your source cluster (Cluster1), connect to the IP and port of your sink cluster (Cluster2) with `riak-repl  connect <sink_ip>:<port>`

	riak-repl connect 127.0.0.1:10046
	
###View your active connections

On your source cluster (Cluster1), view your active connections with `riak-repl connections`

    riak-repl connections

Example output:

```
Connection           Cluster Name         <Ctrl-Pid>      [Members]
----------           ------------         ----------      ---------
Cluster2             Cluster2             <22320.11944.0> ["127.0.0.1:10046",
                                                           "127.0.0.1:10056",
                                                           "127.0.0.1:10066"] (via 127.0.0.1:10066)
```

###Check stats

    riak-repl status

###Insert keys in to "connected" bucket on Cluster 1

```
./riak-ops/curl_put_plain.sh -p 10018 -b connected -f 1 -l 5
```

###Enable Realtime Replication

On your source cluster (Cluster1), enable realtime repl with `riak-repl realtime enable <clustername>`

	riak-repl realtime enable Cluster2

###Check stats

    riak-repl status

###Insert keys in to "enabled" bucket on Cluster 1

```
./riak-ops/curl_put_plain.sh -p 10018 -b enabled -f 1 -l 5
```

###Check stats

    riak-repl status

###Start Realtime Replication
	
On your source cluster (Cluster1) start realtime repl with `riak-repl realtime start <clustername>`

	riak-repl realtime start Cluster2
	

###Check stats

    riak-repl status
    

###Insert keys in to "started" bucket on Cluster 1

```
./riak-ops/curl_put_plain.sh -p 10018 -b started -f 1 -l 5
```
    
###Check stats for send recv data

    riak-repl status


### Testing Real-time Replication

Retrieve the keys from the secondary cluster:

```
./riak-ops/curl_get.sh -p 10048 -b connected -f 1 -l 5
./riak-ops/curl_get.sh -p 10048 -b enabled -f 1 -l 5
./riak-ops/curl_get.sh -p 10048 -b started -f 1 -l 5
```

###More information
	
For a full list of commands, you may enter `riak-repl` to see full instructions on usage.
