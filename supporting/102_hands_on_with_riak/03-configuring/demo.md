# Hands on with Riak - Configuring

## vm.args

Open `etc/vm.args`.

Show the `-name` parameter.

Start Riak.

Run `ps -ef | grep beam` and show the `-name` parameter in the process listing.

Explain that the `-name` parameter is specific to Erlang and required to be
unique for every running Erlang process on a particular machine.

Run `riak-admin test`.

Stop Riak.

Open `etc/vm.args`.

Change the `-name` parameter (e.g. RIAK@127.0.0.1).

Start Riak.

Note that Riak fails to start now the Erlang name has been changed.

Run `riak-admin test`.

Explain that Riak maintains a ring file that notes the name of nodes that
belong to the cluster. In this case the ring file is still referencing the old
node name. Since there are no nodes running with the old node name, requests
cannot be processed.

Run `riak console`.

Explain the `orddict,fetch,['RIAK@127.0.0.1',[{'riak@127.0.0.1'` is effectively saying it can't match the current name with the name of a node in the ring file.

Change the `-name` parameter back (e.g. riak@127.0.0.1).

Start Riak.

Run `riak-admin test`.