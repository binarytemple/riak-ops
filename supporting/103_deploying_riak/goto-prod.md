# Riak Operations -- Going to Production

## System

 * Are all systems in your cluster as close to identical in both hardware and software as possible?
 * Have you set the open files limit on your systems? ([Docs](http://docs.basho.com/riak/latest/ops/tuning/open-files-limit/))
 * Have you applied the Linux tuning recommendations? ([Docs](http://docs.basho.com/riak/latest/ops/tuning/linux/))
 * Have you applied the filesystem scheduler recommendations? ([Docs](http://docs.basho.com/riak/latest/ops/tuning/file-system/))

## Network

 * Are all systems using the same NTP source to synchronize clocks?
 * Are your NTP clients' configurations monotonic (i.e. will not roll back the clock)?
 * Is DNS correctly configured for all systems' production deployments?
 * Are connections correctly routed between all nodes?
 * Are connections correctly routed between your load balancer and all nodes?
 * Are your firewalls configured correctly? ([Docs](http://docs.basho.com/riak/latest/ops/advanced/security/))
 * Confirm network latency and throughput is as expected (Suggested: [iperf](http://iperf.fr/))
    * Between nodes in the cluster
    * Between the LB and all nodes in the cluster
    * Between application servers and the LB
 * Do all Riak nodes appear in the LB rotation
 * Is the LB configured to balance connections with roundrobin, or a similarly
   random distribution scheme? ([Docs](http://docs.basho.com/riak/latest/ops/advanced/configs/load-balancing-proxy/))?

## Riak

 * Check configuration files:
    * Does each machine have the correct name and IP settings in `app.config` and `vm.args`?
    * Are all the `app.config` tuning settings identical across the cluster?
    * Are all the `vm.args` tuning settings identical across the cluster?
    * Are all settings in both files that were changed for debugging purposes reverted to production settings?
    * If using multibackend, are all your buckets configured to use the correct backend?
    * If using multibackend, do all machines' config files agree on their configuration?
    * Do all nodes agree on the value of the `allow_mult` setting?
    * Do you have a sibling resolution strategy in place if using `allow_mult` `true`?
    * Have you carefully weighed the consistency tradeoffs made if using `allow_mult` `false`?
    * Are all the CAP controls configured correctly, and uniformly across the cluster? ([Docs](http://docs.basho.com/riak/latest/dev/advanced/cap-controls/))
    * If you need Riak Search, is it enabled on all nodes? If you don't, is it disabled?
    * If you are using Riak Control, is it enabled on the node(s) you intend to use it from?
 * Check data mount points:
    * Is `/var/lib/riak` mounted?
    * Can you grow that disk later when it starts filling up?
    * Do all nodes have their own storage systems (i.e. no SANs), or do you have a plan to switch to that configuration later?
 * Are all Riak nodes up?
    * Check `riak ping`: should get `pong`
    * Check `riak-admin wait-for-service riak_kv <name>@<IP>`: should get `riak_kv is up`.

      The name@IP string should come from your `vm.args` in a section at the top that looks like this:

            ## Name of the riak node
            -name riak@127.0.0.1

 * Do all nodes agree on the ring state (run on any node)?
    * Check `riak-admin ringready`: Should get `TRUE All nodes agree on the ring ...`
    * Check `riak-admin member-status`: All nodes should be valid, all nodes should appear in the list
    * Check `riak-admin ring-status`: Ring should be ready, no unreachable nodes, no pending changes
    * Check `riak-admin transfers`: No transfers should be occurring or pending

## Operations

 * Does your monitoring system ensure NTP is running?
 * Are you collecting time series data on the whole cluster ([Docs](http://docs.basho.com/riak/latest/ops/running/stats-and-monitoring/))?
    * System metrics
        * CPU Load
        * Memory Used (for applications? for cache?)
        * Network throughput
        * Disk space used/avail
        * Disk IOPS
    * Riak metrics (from the /stats http endpoint or `riak-admin status`)
        * Latencies: GET and PUT, mean/median/95th/99th/100th
        * VNode Stats: GETs, PUTs, GET totals, PUT totals
        * Node Stats: GETs, PUTs, GET totals, PUT totals
        * FSM Stats:
            * GET/PUT FSM objsize 99th and 100th percentile
            * GET/PUT FSM times: mean/median/95th/99th/100th
        * Connection Stats: pbc_connects, pbc_active, pbc_connects_total
 * Can you graph the above, at least the key metrics:
    * Basic system stats
    * Median, 95th, and 99th percentile latencies (these tend to be leading indicators of trouble)

## Application & Load

 * Have you benchmarked your cluster with simulated load to confirm your
   configuration will meet your performance needs?
 * Are the client libraries in use in your application up to date?
 * Do the client libraries you use support the version of Riak you're deploying?

## Confirming Configuration with Riaknostic

Recent versions of Riak ship with a diagnostic utility which can be invoked by
running `riak-admin diag <check>` where `check` is one of:

    disk, dumps, memory_use, nodes_connected, ring_membership,
    ring_preflists, ring_size, search, sysctl

Running `riak-admin diag` with no additional arguments will run all checks and
report the findings. This is a great way to verify that you've got some of the
configurations mentioned above correct, and that all nodes in your cluster are
up, and not grossly misconfigured. Any warnings produced by `riak-admin diag`
should be addressed before going to production.


## Troubleshooting and Support

 * Does your team, operations and development, know how to open support requests with Basho?
 * Is your team familiar with Basho Support's SLA levels?
    * Normal and Low are for issues not immediately impacting production systems
    * High is for problems that impact production or soon-to-be-production systems, but where stability is not currently compromised.
    * Urgent is for problems causing production outages, or those likely to turn in to production outages very soon. On-call engineers respond to urgent requests within 30 minutes, 24/7.
 * Does your team know how to gather `riak-debug` results from the whole cluster when opening tickets?
    * SSH to each machine, run `riak-debug`, grab the resultant `.tar.gz` file.
    * Attach debug tarballs from the whole cluster each time you open a new High or Urgent priority ticket

## Taking it to Production

Once you've been running in production for a month or so, look back at the
metrics gathered above. Based on the numbers you're seeing so far, configure
alerting thresholds on your latencies, disk consumption, and memory. These
are the places most likely to give you advance warning of trouble.

When you go to increase capacity down the line, having historic metrics will
give you very clear indicators of having resolved scaling problems, as well
as metrics for understanding what to upgrade and when.