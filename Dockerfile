FROM centos:latest


ARG JMETER_VERSION="3.3"

ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN  ${JMETER_HOME}/bin
ENV MIRROR_HOST http://mirrors.ocf.berkeley.edu/apache/jmeter
ENV JMETER_DOWNLOAD_URL ${MIRROR_HOST}/binaries/apache-jmeter-${JMETER_VERSION}.tgz
ENV JMETER_PLUGINS_DOWNLOAD_URL http://repo1.maven.org/maven2/kg/apc
ENV JMETER_PLUGINS_FOLDER ${JMETER_HOME}/lib/ext/

# Install necessary packages
RUN yum repolist > /dev/null && \
     yum-config-manager --enable rhel-7-server-optional-rpms && \
     yum clean all && \
     INSTALL_PKGS="tar \
        unzip \
        wget \
        which \
        yum-utils \
        java-1.8.0-openjdk-devel" && \
     yum install -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
     rpm -V $INSTALL_PKGS && \
     yum clean all

# Create jmeter directory with tests and results folder
RUN mkdir -p /jmeter/{tests,results}

RUN mkdir -p /tmp/dependencies

RUN curl -L --silent ${JMETER_DOWNLOAD_URL} > /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz

RUN mkdir -p /opt  

RUN tar -xvf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  

RUN rm -rf /tmp/dependencies

ENV PATH $PATH:$JMETER_BIN

WORKDIR ${JMETER_HOME}

