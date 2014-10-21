# Riak Tools & Cluster Operations - Cluster Changes

## Example cluster operations

Set transfer-limit to 8

    dev1/bin/riak-admin transfer-limit 8

### Leave node 1

Run the node leave commend on the node

    dev1/bin/riak-admin cluster leave

__OR__ on another node and pass in the node name

    dev3/bin/riak-admin cluster leave dev1@127.0.0.1
    
Plan and commit the cluster changes
    
    dev1/bin/riak-admin cluster plan
    dev1/bin/riak-admin cluster commit

Observe transfers with the riak-admin command and watch the partitions move

    watch dev1/bin/riak-admin transfers
    watch -d ls dev{1..5}/data/bitcask

The leaving node will stop and clear it's ring file

Remove the data directory from node 1
        
    rm -rf dev1/data/*

### Replace node 4 with node 1

    dev1/bin/riak start
    dev1/bin/riak-admin cluster join dev3@127.0.0.1
    dev3/bin/riak-admin cluster replace dev4@127.0.0.1 dev1@127.0.0.1
    dev3/bin/riak-admin cluster plan
    dev3/bin/riak-admin cluster commit

### Force replace dead node 3 with node 4

Kill -9 node 3

    kill -9 $(ps -ef | grep dev3 | grep beam | awk '{print $2}')
    
Start node 4
    
    dev4/bin/riak start

Observe individual member status

    dev1/bin/riak-admin member-status
    dev1/bin/riak-admin down dev3@127.0.0.1
    dev4/bin/riak-admin cluster join dev1@127.0.0.1

Observe individual member status

    dev1/bin/riak-admin member-status
    dev1/bin/riak-admin cluster force-replace dev3@127.0.0.1 dev4@127.0.0.1
    dev1/bin/riak-admin cluster plan
    dev1/bin/riak-admin cluster commit