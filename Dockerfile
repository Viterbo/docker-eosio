FROM ubuntu:18.04

ARG USER_ID
ARG GROUP_ID

RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update --fix-missing

RUN apt-get install -y wget make git curl 

# Python 9
# https://linuxize.com/post/how-to-install-python-3-9-on-ubuntu-20-04/
RUN apt-get install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev
RUN cd /tmp; wget https://www.python.org/ftp/python/3.9.1/Python-3.9.1.tgz
RUN cd /tmp; tar -xf Python-3.9.1.tgz
RUN cd /tmp; cd Python-3.9.1; ./configure --enable-optimizations
RUN cd /tmp; cd Python-3.9.1; make -j 12
RUN cd /tmp; cd Python-3.9.1; make altinstall
RUN python3.9 --version

# https://developers.eos.io/welcome/latest/getting-started/development-environment/introduction

# /usr/opt/eosio/2.0.13
RUN wget https://github.com/EOSIO/eos/releases/download/v2.0.13/eosio_2.0.13-1-ubuntu-18.04_amd64.deb

# /usr/opt/eosio/2.0.0
# RUN wget https://github.com/EOSIO/eos/releases/download/v2.0.0/eosio_2.0.0-1-ubuntu-18.04_amd64.deb

# /usr/opt/eosio/1.8.14
# RUN wget https://github.com/EOSIO/eos/releases/download/v1.8.14/eosio_1.8.14-1-ubuntu-18.04_amd64.deb

# /usr/opt/eosio.cdt/1.8.1
RUN wget https://github.com/EOSIO/eosio.cdt/releases/download/v1.8.1/eosio.cdt_1.8.1-1-ubuntu-20.04_amd64.deb

# /usr/opt/eosio.cdt/1.7.0
# RUN wget https://github.com/EOSIO/eosio.cdt/releases/download/v1.7.0/eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb

# /usr/opt/eosio.cdt/1.6.3
# RUN wget https://github.com/EOSIO/eosio.cdt/releases/download/v1.6.3/eosio.cdt_1.6.3-1-ubuntu-18.04_amd64.deb

RUN pwd && ls -las

RUN apt-get install -y ./eosio_2.0.13-1-ubuntu-18.04_amd64.deb

RUN apt-get install -y ./eosio.cdt_1.8.1-1-ubuntu-20.04_amd64.deb

RUN apt-get install -y mlocate; updatedb

COPY entrypoint.sh /

COPY logging.json /

RUN apt-get install -y jq

# RUN echo "alias ll='ls -las'" >> /etc/profile.d/aliases.sh
# RUN echo "alias telosmain='cleos --url https://telos.caleos.io '" >> /etc/profile.d/aliases.sh
# RUN echo "alias telostest='cleos --url https://testnet.telos.caleos.io '" >> /etc/profile.d/aliases.sh
# RUN chmod +x /etc/profile.d/aliases.sh

# support for icons on the command line
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color
ENV PS1="\[\e[0;32m\]\u@\h \[\e[0;33m\]\w\[\e[0m\]\n\[\e[1;34m\]\\$ \[\e[0m\]"
ENV PYTHONIOENCODING=utf-8
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app
RUN apt-get install -y fonts-dejavu
# Set the default shell to bash
ENV SHELL=/bin/bash
ENV HISTFILE=

WORKDIR /app

USER user

ENTRYPOINT ["/entrypoint.sh"]

HEALTHCHECK --interval=5s --timeout=10s --retries=3 CMD tail -n 1 /tmp/nodeos.log