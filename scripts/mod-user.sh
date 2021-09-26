#!/bin/bash -eu

shopt -s dotglob

mv /tmp/dot_files_git/dotfiles/* /home/$USER_NAME

usermod -u $USER_ID $USER_NAME
groupmod -g $GROUP_ID $GROUP_NAME

echo 'source /opt/ros/kinetic/setup.bash' >> /home/${USER_NAME}/.bashrc && \
echo "source ${ROS_HOME}/devel/setup.bash" >> /home/${USER_NAME}/.bashrc && \
echo "alias cs='cd ${ROS_HOME}/src'" >> /home/${USER_NAME}/.bashrc && \
echo "alias ba='cur=\$(pwd); cd ${ROS_HOME}; catkin_make; cd \$cur'" >> /home/${USER_NAME}/.bashrc && \
echo "alias ali='apt list --installed'" >> /home/${USER_NAME}/.bashrc 

chown -R $USER_NAME:$GROUP_NAME /home/$USER
gosu $USER_NAME:$GROUP_NAME /bin/bash