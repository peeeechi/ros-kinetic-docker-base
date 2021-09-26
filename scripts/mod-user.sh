#!/bin/bash -eu

usermod -u $USER_ID $USER_NAME
groupmod -g $GROUP_ID $GROUP_NAME
chown -R $USER_NAME:$GROUP_NAME /home/$USER
gosu $USER_NAME:$GROUP_NAME /bin/bash