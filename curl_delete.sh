#!/usr/bin/env bash

# Set some defaults
riak_ip="localhost"
riak_port="8098"
bucket_type="default"
bucket="b1"
start_key="1"
end_key="100"

# Usage output
usage()
{
cat << EOF
USAGE: $0 -s <riak_ip> -p <riak_port> -t <bucket_type> -b <bucket> -f <first_key> -l <last_key>

OPTIONS:
  -h      Show this message
  -s      Riak IP
  -p      Riak port
  -t      Bucket Type
  -b      Bucket
  -f      First key
  -l      Last key
EOF
}

# Get options
while getopts "hs:p:t:b:f:l:" option;
do
  case $option in
    h)
      usage
      exit 1
    ;;
    s)
      riak_ip=$OPTARG
    ;;
    p)
      riak_port=$OPTARG
    ;;
    t)
      bucket_type=$OPTARG
    ;;
    b)
      bucket=$OPTARG
    ;;
    f)
      start_key=$OPTARG
    ;;
    l)
      end_key=$OPTARG
    ;;
  esac
done

# Exit if start_key is > end_key
if [ $start_key -gt $end_key ]; then
  echo "ERROR: <first_key> must be less than <last_key>"
  exit 1
fi

# Define bucket url based on Riak version
if [ $bucket_type != "default" ]; then
  riak_bucket_url="http://${riak_ip}:${riak_port}/types/${bucket_type}/buckets/${bucket}/"
else
  riak_bucket_url="http://${riak_ip}:${riak_port}/buckets/${bucket}/"
fi

# Exit if Riak is not running
riak_http_check="$(curl ${riak_ip}:${riak_port}/stats -sI | head -1 | awk '{print $2}')"
if [ -z $riak_http_check ] || [ $riak_http_check -ne 200 ]; then
  echo "ERROR: Riak is not available at ${riak_ip}:${riak_port}"
  exit 1
fi

# Run DELETE loop
let key=$start_key
while [ $key -le $end_key ]; do
  echo "INFO: DELETE - ${riak_bucket_url}keys/${key}"
  curl -XDELETE ${riak_bucket_url}keys/${key}
  let key=key+1
done
