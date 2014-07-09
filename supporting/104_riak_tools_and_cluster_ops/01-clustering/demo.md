# Riak Tools & Cluster Operations - Clustering

Change to the devrel base directory

    cd dev

Start each node:

    dev1/bin/riak start
    dev2/bin/riak start
    dev3/bin/riak start
    dev4/bin/riak start
    dev5/bin/riak start

Show all nodes running (Note the -name field in each process):

    ps -ef | grep beam

Show the usage of the cluster command:

    dev1/bin/riak-admin cluster

Stage a join of dev1 to dev2:

    dev2/bin/riak-admin cluster join dev1@127.0.0.1

Review the impending changes:

    dev2/bin/riak-admin cluster plan

Note how half the default ring size (32 of 64) is set to transfer. Add dev3 to this plan:

    dev3/bin/riak-admin cluster join dev1@127.0.0.1

Observe how our plan has changed:

    dev1/bin/riak-admin cluster plan

Commit those changes, and watch the transfers occur using member_status

    dev1/bin/riak-admin cluster commit
    dev1/bin/riak-admin member_status

Join the other nodes, and we have a five node cluster with a ring size of 64.

    dev4/bin/riak-admin cluster join dev1@127.0.0.1
    dev5/bin/riak-admin cluster join dev1@127.0.0.1
    dev1/bin/riak-admin cluster plan
    dev1/bin/riak-admin cluster commit
    dev1/bin/riak-admin member_status

Riak automatically balances the ring via ownership handoff, and we have ~12 vnodes per node.
