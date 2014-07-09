Back up your data directory on the node in question. In this example scenario, we'll call the node riak4:

    sudo tar -czf riak_backup.tar.gz /var/lib/riak /etc/riak

Download and install Riak on the new node you wish to bring into the cluster and have replace the riak4 node. We'll call this node riak7 for the purpose of this example.

Start the new riak7 node with riak start:

    riak start

Plan the join of the new riak7 node to an existing node already participating in he cluster; for example riak0 with the riak-admin cluster join command executed on the the new riak7 node:

    riak-admin cluster join riak0

Plan the replacement of the existing riak4 node with the new riak7 node using the riak-admin cluster replace command:

    riak-admin cluster replace riak4 riak7

###Single Nodes

If a node is started singly using default settings (as, for example, you might do when you are building your first test environment), you will need to remove the ring files from the data directory after you edit etc/vm.args. riak-admin cluster replace will not work as the node has not been joined to a cluster.

Examine the proposed cluster changes with the riak-admin cluster plan command executed on the the new riak7 node:

    riak-admin cluster plan

If the changes are correct, you can commit them with the riak-admin cluster commit command:

    riak-admin cluster commit