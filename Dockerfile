FROM centos:7 AS builder

ARG APACHE_MAVEN_VERSION=3.6.3

## Install build dependencies
RUN yum install -y unzip

RUN cd /opt \
    && curl -s http://mirror.cogentco.com/pub/apache/maven/maven-3/${APACHE_MAVEN_VERSION}/binaries/apache-maven-${APACHE_MAVEN_VERSION}-bin.zip \
        > apache-maven-${APACHE_MAVEN_VERSION}-bin.zip \
    && unzip apache-maven-${APACHE_MAVEN_VERSION}-bin.zip

FROM centos:7

ARG JMETER_VERSION=5.1.1
ENV JMETER_HOME /opt/apache-jmeter

## Install jMeter dependencies
RUN yum install -y -q java bc \
    && yum clean all \
    && rm -rf /var/cache/yum

## Install Apache jMeter
RUN curl -s https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz \
        > apache-jmeter-${JMETER_VERSION}.tgz \
    && tar xzf apache-jmeter-${JMETER_VERSION}.tgz \
    && rm apache-jmeter-${JMETER_VERSION}.tgz \
    && mv apache-jmeter-${JMETER_VERSION} ${JMETER_HOME}

## Install the PluginManager
RUN cd ${JMETER_HOME} \
    && curl -sL 'http://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/1.3/jmeter-plugins-manager-1.3.jar' \
        > lib/ext/jmeter-plugins-manager-1.3.jar \
    && curl -sL http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.2/cmdrunner-2.2.jar \
        > lib/cmdrunner-2.2.jar \
    && java -cp lib/ext/jmeter-plugins-manager-1.3.jar org.jmeterplugins.repository.PluginManagerCMDInstaller

## Install additional libraries
RUN curl -sL https://search.maven.org/remotecontent?filepath=com/google/code/gson/gson/2.8.5/gson-2.8.5.jar \
        > ${JMETER_HOME}/lib/gson-2.8.5.jar

## Copy Apache Maven binary from builder image
COPY --from=builder /opt/apache-maven-*/lib/maven-artifact-*.jar ${JMETER_HOME}/lib/

ENV PATH $PATH:/opt/apache-jmeter/bin
COPY docker-entrypoint /usr/local/bin

ENTRYPOINT ["docker-entrypoint"]
CMD ["jmeter"]
