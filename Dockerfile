FROM centos:7

RUN yum install -y -q java bc

ARG JMETER_VERSION=5.1.1
ENV JMETER_HOME /opt/apache-jmeter

RUN curl -s https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz \
        > apache-jmeter-${JMETER_VERSION}.tgz \
    && tar xzf apache-jmeter-${JMETER_VERSION}.tgz \
    && rm apache-jmeter-${JMETER_VERSION}.tgz \
    && mv apache-jmeter-${JMETER_VERSION} /opt/apache-jmeter \
    && cd /opt/apache-jmeter \
    && curl -s 'http://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/1.3/jmeter-plugins-manager-1.3.jar' \
        > lib/ext/jmeter-plugins-manager-1.3.jar \
    && curl -s http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.2/cmdrunner-2.2.jar \
        > lib/cmdrunner-2.2.jar \
    && java -cp lib/ext/jmeter-plugins-manager-1.3.jar org.jmeterplugins.repository.PluginManagerCMDInstaller \
    && ./bin/PluginsManagerCMD.sh upgrades

ENV PATH $PATH:/opt/apache-jmeter/bin
COPY docker-entrypoint /usr/local/bin

ENTRYPOINT ["docker-entrypoint"]
CMD ["jmeter"]
