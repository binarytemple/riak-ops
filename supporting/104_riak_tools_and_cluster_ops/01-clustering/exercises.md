# Riak Tools & Cluster Operations - Cluster Changes

## example cluster operations

## leave node 1

    dev1/bin/riak-admin cluster leave
    dev3/bin/riak-admin cluster leave dev1@127.0.0.1

observe transfers

    watch -d dev1/bin/riak-admin transfers
    watch -d ls dev{1..5}/data/leveldb

the leaving node will stop

## wipe node 1
        
    rm -rf dev1/data/*

## use node 1 as a replacement for node 4

    dev1/bin/riak start
    dev1/bin/riak-admin cluster join dev3@127.0.0.1
    dev3/bin/riak-admin cluster replace dev4@127.0.0.1 dev1@127.0.0.1
    dev3/bin/riak-admin cluster plan
    dev3/bin/riak-admin cluster commit

## kill node 3

    kill -9 $(ps -ef | grep dev3 | grep beam | awk '{print $2}')

## force remove node 3
        
    dev1/bin/riak-admin cluster force-remove dev3@127.0.0.1

## force replace node 5 (any non-claimant) with node 1

    kill -9 $(ps -ef | grep dev5 | grep beam | awk '{print $2}')
    dev1/bin/riak start
    dev3/bin/riak-admin member-status

observe individual member status

    dev3/bin/riak-admin down dev5@127.0.0.1
    dev1/bin/riak-admin cluster join dev3@127.0.0.1
    dev3/bin/riak-admin member-status

observe individual member status

    dev3/bin/riak-admin cluster force-replace dev5@127.0.0.1 dev1@127.0.0.1
    dev3/bin/riak-admin cluster plan
    dev3/bin/riak-admin cluster commit