#!/bin/bash -eu

scrip_dir=`dirname $0`

repo=my-image
image=ros
tag=kinetic

registry_host=localhost
registry_port=5000

docker image build -t $repo/$image:$tag -f $scrip_dir/../Dockerfile $scrip_dir/..
# docker tag $repo/$image:$tag $registry_host:$registry_port/$image:$tag
# docker push $registry_host:$registry_port/$image:$tag