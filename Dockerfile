# Modified galaxy with environment modules and singularity
# https://hub.docker.com/r/bgruening/galaxy-stable/
# latest

# base image: galaxy-stable
FROM bgruening/galaxy-stable:latest

# File Author / Maintainer
MAINTAINER Frederic Lemoine <frederic.lemoine@pasteur.fr>

ENV MODULE_PACKAGES="/packages"

RUN apt-get update --fix-missing \
    && apt-get install wget \
    && sudo apt-get update \
    && apt-get install -y environment-modules squashfs-tools libtool libarchive-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/singularityware/singularity.git \
    && cd singularity \
    && git checkout development \
    && ./autogen.sh \
    && ./configure --prefix=/usr/local \
    && make \
    && make install

COPY init_modules.sh /
COPY package_list.txt /

RUN mkdir /packages \
    && cd / \
    && ./init_modules.sh

RUN echo "source /usr/share/modules/init/bash" >> /etc/bash.bashrc
RUN echo "source /usr/share/modules/init/sh" >> /etc/profile


COPY dependency_resolvers_conf.xml /galaxy-central/config/dependency_resolvers_conf.xml