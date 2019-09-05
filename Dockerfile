FROM centos:7

RUN yum install -y -q java bc

RUN curl -s https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.0.tgz \
        > apache-jmeter-5.0.tgz \
    && tar xzf apache-jmeter-5.0.tgz \
    && cd apache-jmeter-5.0 \
    && curl -s 'http://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/1.3/jmeter-plugins-manager-1.3.jar' \
        > lib/ext/jmeter-plugins-manager-1.3.jar \
    && curl -s http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.2/cmdrunner-2.2.jar \
        > lib/cmdrunner-2.2.jar \
    && java -cp lib/ext/jmeter-plugins-manager-1.3.jar org.jmeterplugins.repository.PluginManagerCMDInstaller \
    && echo 'export PATH=$PATH:$HOME/apache-jmeter-5.0/bin' >> ~/.bashrc \
    && ./bin/PluginsManagerCMD.sh upgrades
