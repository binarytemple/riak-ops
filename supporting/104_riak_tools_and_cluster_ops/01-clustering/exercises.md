# Riak Tools & Cluster Operations - Cluster Changes

## example cluster operations

## set transfer-limit to 8

    dev1/bin/riak-admin transfer-limit 8

## leave node 1

    dev1/bin/riak-admin cluster leave

or

    dev3/bin/riak-admin cluster leave dev1@127.0.0.1
    
then
    
    dev1/bin/riak-admin cluster plan
    dev1/bin/riak-admin cluster commit

observe transfers

    watch dev1/bin/riak-admin transfers
    watch -d ls dev{1..5}/data/leveldb

the leaving node will stop and clear it's ring file

## wipe node 1
        
    rm -rf dev1/data/*

## replace node 4 with node 1

    dev1/bin/riak start
    dev1/bin/riak-admin cluster join dev3@127.0.0.1
    dev3/bin/riak-admin cluster replace dev4@127.0.0.1 dev1@127.0.0.1
    dev3/bin/riak-admin cluster plan
    dev3/bin/riak-admin cluster commit

## force replace dead node 3 with node 4

    kill -9 $(ps -ef | grep dev3 | grep beam | awk '{print $2}')
    dev4/bin/riak start

observe individual member status

    dev1/bin/riak-admin member-status
    dev1/bin/riak-admin down dev3@127.0.0.1
    dev4/bin/riak-admin cluster join dev1@127.0.0.1

observe individual member status

    dev1/bin/riak-admin member-status
    dev1/bin/riak-admin cluster force-replace dev3@127.0.0.1 dev4@127.0.0.1
    dev1/bin/riak-admin cluster plan
    dev1/bin/riak-admin cluster commit