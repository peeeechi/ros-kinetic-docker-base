#!/bin/bash -eu

file_dir=$(dirname $0)
resource_dir="$file_dir/../.env"

if [ ! -d $resource_dir ]; then
    mkdir -p $resource_dir
fi

env_file="$resource_dir/ros-env"

echo "USER_ID=$(id -u)" > $env_file
echo "GROUP_ID=$(id -g)" >> $env_file
echo "DISPLAY=${DISPLAY}" >> $env_file
echo "QT_X11_NO_MITSHM=1" >> $env_file
