# Hands on with Riak - Querying

## Simple GET and PUT Operations

    curl -i -XPUT http://localhost:10018/buckets/random/keys/key_1 -d "Ben"
    curl http://localhost:10018/buckets/random/keys/key_1


## Zombie Data Operations

Insert zombie data

    python bulk_import.py

Kill some nodes

    for d in dev{4..5}; do $d/bin/riak stop; done

Show r and pr reads

    curl http://localhost:10018/buckets/za/keys/310-673-3772 | python -mjson.tool
    curl http://localhost:10018/buckets/za/keys/310-673-3772?pr=3 | python -mjson.tool

Show w and pw writes

    curl -i -XPUT http://localhost:10018/buckets/primary/keys/key_1 -d "Ben"
    curl -i -XPUT http://localhost:10018/buckets/primary/keys/key_2?pw=3 -d "Bob"

(PW-value unsatisfied: 2/3)

Show metadata in curl requests

    curl -i http://localhost:10018/buckets/za/keys/310-673-3772

Some 2i querys

    curl http://localhost:10018/buckets/za/index/city_bin/Wytheville | python -mjson.tool
    curl http://localhost:10018/buckets/za/index/state_bin/CA | python -mjson.tool
    curl http://localhost:10018/buckets/za/index/blood_bin/O%2B | python -mjson.tool

2i range queries

    curl http://localhost:10018/buckets/za/index/weight_bin/220/240 | python -mjson.tool
    curl http://localhost:10018/buckets/za/index/weight_bin/220/222?return_terms=true | python -mjson.tool