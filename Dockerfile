FROM osrf/ros:kinetic-desktop-full

ENV DEBIAN_FRONTEND noninteractive
# SHELL ["/bin/bash", "-c"]

ENV USER_NAME rosuser 
ENV GROUP_NAME ${USER_NAME}
ENV USER_ID 2000
ENV GROUP_ID 2000
ARG PASSWORD=ros

RUN apt-get update && \
    apt-get install -y \
    ca-certificates \
    openssh-server \
    vim \
    xclip \
    gosu \
    sudo \
    iproute2 \
    gnupg-curl \
    apt-transport-https \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 日本語設定
RUN apt-get update && apt-get install -y --no-install-recommends \
    language-pack-ja-base \
    language-pack-ja \
    fonts-ipafont-gothic && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py && \
    python get-pip.py; \
    rm -f get-pip.py

ENV ROS_HOME=/home/${USER_NAME}/catkin_ws

# -m, --create-home     ホームディレクトリを作成します。
# -s, --shell SHELL     ログインシェルを指定します。
# -u, --uid USER_ID         ユーザーIDを指定します。
# -g, --gid GROUP       プライマリグループのグループ名かグループIDを指定します。
#                       ちなみに省略した場合、環境によって「ユーザー名と同じグループ名が新たに作成される」
#                       「/etc/default/useraddに記述されたグループID」「デフォルトの100」のいずれかになるようです。

RUN groupadd -g ${GROUP_ID} ${GROUP_NAME} && \
    useradd -m -s /bin/bash -u ${USER_ID} -g ${GROUP_ID} ${USER_NAME} && \
    echo ${USER_NAME}:${PASSWORD} | chpasswd && \
    usermod -G sudo ${USER_NAME} && \
    mkdir -p ${ROS_HOME}/src && \
    cd /tmp && \
    git clone https://github.com/peeeechi/dotfiles.git dot_files_git && \
    chown -R ${USER_NAME}:${GROUP_NAME} /home/${USER_NAME}

# WORKDIR /home/${USER_NAME}
# RUN mv /home/${USER_NAME}/dotfiles/.* /home/${USER_NAME}


# RUN rosdep init
USER ${USER_NAME}

WORKDIR ${ROS_HOME}
RUN rosdep update && \
    echo 'source /opt/ros/kinetic/setup.bash' >> /home/${USER_NAME}/.bashrc && \
    echo "source ${ROS_HOME}/devel/setup.bash" >> /home/${USER_NAME}/.bashrc && \
    echo "alias cs='cd $ROS_HOME/src'" >> /home/${USER_NAME}/.bashrc && \
    echo "alias ba='cur=$(pwd); cd $ROS_HOME; catkin_make; cd ${cur}'" >> /home/${USER_NAME}/.bashrc && \
    echo "alias ali='apt list --installed'" >> /home/${USER_NAME}/.bashrc 

COPY ./scripts/mod-user.sh /tmp/mod-user.sh
USER root

ENTRYPOINT [ "/bin/bash", "/tmp/mod-user.sh" ]
