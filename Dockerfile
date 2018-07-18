FROM centos:latest

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

# Install JMeter
ADD apache-jmeter-3.1.tgz /jmeter
ADD JMeterPlugins-ExtrasLibs-1.4.0.zip /jmeter/apache-jmeter-3.1/
RUN unzip -o /jmeter/apache-jmeter-3.1/JMeterPlugins-ExtrasLibs-1.4.0.zip -d /jmeter/apache-jmeter-3.1/ \
    && rm -rf /jmeter/apache-jmeter-3.1/JMeterPlugins-ExtrasLibs-1.4.0.zip

# Set JMeter Home
ENV JMETER_HOME /jmeter/apache-jmeter-3.1/

# Add JMeter to the Path
ENV PATH $JMETER_HOME/bin:$PATH

# Set working directory
WORKDIR /jmeter