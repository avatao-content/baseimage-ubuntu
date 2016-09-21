FROM ubuntu:16.04

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 \
    DEBIAN_FRONTEND=noninteractive

# Install common packages
RUN sed -i 's://archive.ubuntu.com://de.archive.ubuntu.com:g' /etc/apt/sources.list \
    && dpkg --add-architecture i386 \
    && apt-get -qy update \
    && apt-get -qy dist-upgrade \
    && apt-get -qy install \
        autoconf \
        automake \
        autotools-dev \
        build-essential \
        curl \
        flex \
        g++-multilib \
        gcc-multilib \
        git \
        libc6-dev \
        libc6-dev-i386 \
        man-db \
        nano \
        netcat \
        openssh-server \
        psmisc \
        python-dev \
        python-flask \
        python-pip \
        python-requests \
        python-urllib3 \
        python3-dev \
        python3-flask \
        python3-pip \
        screen \
        socat \
        sqlite \
        subversion \
        sudo \
        tmux \
        vim \
    && rm -rf /var/lib/apt/lists/*

# Set up the non-privileged user and SSH
RUN adduser --disabled-password --gecos ',,,' user \
    && echo 'user:p' | chpasswd \
    && ssh-keygen -f /etc/ssh/ssh_user_ed25519_key -t ed25519 -N '' \
    && ssh-keygen -f /etc/ssh/ssh_user_ecdsa_key -t ecdsa -N '' \
    && ssh-keygen -f /etc/ssh/ssh_user_rsa_key -t rsa -N '' \
    && chown user:user /etc/ssh/ssh_user_* \
    && mkdir -pm 0700 /var/run/sshd # PrivilegeSeparation as root

COPY . /

# Override with --tmpfs since docker 1.10
VOLUME ["/tmp", "/var/tmp"]
