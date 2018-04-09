# Modified galaxy with environment modules and singularity
# https://hub.docker.com/r/bgruening/galaxy-stable/
# latest

# base image: galaxy-stable
FROM bgruening/galaxy-stable:latest

# File Author / Maintainer
MAINTAINER Frederic Lemoine <frederic.lemoine@pasteur.fr>

ENV MODULE_PACKAGES="/packages"

## Install environment modules
RUN apt-get update --fix-missing \
    && apt-get install wget \
    && sudo apt-get update \
    && apt-get install -y environment-modules squashfs-tools libtool libarchive-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

## Install Singularity
RUN git clone https://github.com/singularityware/singularity.git \
    && cd singularity \
    && git checkout development \
    && ./autogen.sh \
    && ./configure --prefix=/usr/local \
    && make \
    && make install

## Copy docker init files
COPY docker/init_modules.sh $GALAXY_HOME/docker/
COPY docker/package_list.txt $GALAXY_HOME/docker/

## Installs singularity images and their
## available commands into module paths
RUN mkdir /packages \
    && cd $GALAXY_HOME/docker/ \
    && ./init_modules.sh

## Auto initialize environment modules for bash and sh
RUN echo "source /usr/share/modules/init/bash" >> /etc/bash.bashrc
RUN echo "source /usr/share/modules/init/sh" >> /etc/profile

## COPY Galaxy conf files into right directories
COPY docker/dependency_resolvers_conf.xml /galaxy-central/config/dependency_resolvers_conf.xml
COPY docker/environment_modules_mapping.yml /galaxy-central/config/environment_modules_mapping.yml
## COPY tool wrappers
COPY tools /local_tools/
## COPY workflows
COPY workflows/* $GALAXY_HOME/workflows/

# We make galaxy folders available to singularity runs
RUN echo "bind path = /export:/export" >> /usr/local/etc/singularity/singularity.conf \
    && echo "bind path = /data:/data" >> /usr/local/etc/singularity/singularity.conf

# We import workflows
RUN startup_lite && \
    galaxy-wait && \
    workflow-install --workflow_path $GALAXY_HOME/workflows/ -g http://localhost:8080 -u $GALAXY_DEFAULT_ADMIN_USER -p $GALAXY_DEFAULT_ADMIN_PASSWORD

RUN cat /galaxy-central/config/datatypes_conf.xml.sample  | \
        sed 's/extension="phylip"/extension="phylip" display_in_upload="true"/' > /galaxy-central/config/datatypes_conf.xml
