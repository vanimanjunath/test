FROM ubuntu:latest
RUN apt -y update && apt install -y curl && apt -y install openjdk-8-jdk && apt -y clean
USER jboss
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk
ENV WILDFLY_VERSION 16.0.0.Final
ENV WILDFLY_SHA1 287c21b069ec6ecd80472afec01384093ed8eb7d
ENV JBOSS_HOME /opt/wildfly

USER root
RUN cd $HOME \
    && groupadd -r wildfly \
    && useradd -r -g wildfly -d /opt/wildfly -s /sbin/nologin wildfly \
    && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
    && sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
    && tar xf wildfly-$WILDFLY_VERSION.tar.gz \
    && mv wildfly-$WILDFLY_VERSION /opt/ \
    && rm wildfly-$WILDFLY_VERSION.tar.gz \
    && ln -s /opt/wildfly-$WILDFLY_VERSION /opt/wildfly \
    && chown -RH wildfly: ${JBOSS_HOME} \
    && chmod -R g+rw ${JBOSS_HOME}
ENV LAUNCH_JBOSS_IN_BACKGROUND true
CMD ["/opt/wildfly/bin/standalone.sh", "-b", "0.0.0.0" -Djboss.management.http.port=8808]
EXPOSE 8808