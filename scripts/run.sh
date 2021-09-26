#!/bin/bash -eu

scrip_dir=`dirname $0`

$scrip_dir/create-env-file.sh
docker-compose -f $scrip_dir/../docker-compose.yml run --rm ros