FROM jolokia/alpine-jre-8
MAINTAINER Klaus Schröder klaus.schroeder@commerce-plus.com

# Set environment variables
ENV ES_NAME elasticsearch
ENV ELASTICSEARCH_VERSION 2.2.0
ENV ELASTICSEARCH_URL https://download.elastic.co/$ES_NAME/$ES_NAME/$ES_NAME-$ELASTICSEARCH_VERSION.tar.gz

ENV LOGSTASH_NAME logstash
ENV LOGSTASH_VERSION 2.1.3
ENV LOGSTASH_URL https://download.elastic.co/$LOGSTASH_NAME/$LOGSTASH_NAME/$LOGSTASH_NAME-$LOGSTASH_VERSION.tar.gz

ENV KIBANA_VERSION 4.4.1
ENV KIBANA_NAME kibana
ENV KIBANA_PKG $KIBANA_NAME-$KIBANA_VERSION-linux-x64
ENV KIBANA_CONFIG /opt/$KIBANA_NAME-$KIBANA_VERSION-linux-x64/config/kibana.yml
ENV KIBANA_URL https://download.elastic.co/$KIBANA_NAME/$KIBANA_NAME/$KIBANA_PKG.tar.gz


# Download Elasticsearch
RUN apk add --update openssl nodejs bash sudo curl
RUN mkdir -p /opt \
    && echo "[i] Building elasticsearch" \
    && echo curl -s -L -o /tmp/$ES_NAME-$ELASTICSEARCH_VERSION.tar.gz $ELASTICSEARCH_URL \
    && curl -s -L -o /tmp/$ES_NAME-$ELASTICSEARCH_VERSION.tar.gz $ELASTICSEARCH_URL \
    && tar -xzf /tmp/$ES_NAME-$ELASTICSEARCH_VERSION.tar.gz -C /opt/ \
    && ln -s /opt/$ES_NAME-$ELASTICSEARCH_VERSION /opt/$ES_NAME \
    && addgroup -S elasticsearch \
    && adduser -S -h /opt/$ES_NAME -G elasticsearch elasticsearch \
    && mkdir /var/lib/elasticsearch \
    && chown -RH elasticsearch:elasticsearch /opt/$ES_NAME /var/lib/elasticsearch
RUN echo "[i] Building logstash" \
    && echo curl -s -L -o /tmp/$LOGSTASH_NAME-$LOGSTASH_VERSION.tar.gz $LOGSTASH_URL \
    && curl -s -L -o /tmp/$LOGSTASH_NAME-$LOGSTASH_VERSION.tar.gz $LOGSTASH_URL \
    && tar xzf /tmp/$LOGSTASH_NAME-$LOGSTASH_VERSION.tar.gz -C /opt/ \
    && ln -s /opt/$LOGSTASH_NAME-$LOGSTASH_VERSION /opt/$LOGSTASH_NAME \
    && addgroup -S logstash \
    && adduser -S -h /opt/$LOGSTASH_NAME -G logstash logstash \
    && mkdir -p /etc/$LOGSTASH_NAME /etc/$LOGSTASH_NAME/conf.d /var/log/$LOGSTASH_NAME /opt/$LOGSTASH_NAME/patterns \
    && chown -RH logstash:logstash /opt/$LOGSTASH_NAME /var/log/$LOGSTASH_NAME
RUN echo "[i] Building kibana" \
    && echo curl -s -L -o /tmp/$KIBANA_PKG.tar.gz $KIBANA_URL \
    && curl -s -L -o /tmp/$KIBANA_PKG.tar.gz $KIBANA_URL \
    && tar -xzf /tmp/$KIBANA_PKG.tar.gz -C /opt/ \
    && ln -s /opt/$KIBANA_PKG /opt/$KIBANA_NAME \
    && addgroup -S kibana \
    && adduser -S -h /opt/$KIBANA_NAME -G kibana kibana \
    && rm -rf /opt/$KIBANA_PKG/node/ \
    && mkdir -p /opt/$KIBANA_PKG/node/bin/ \
    && ln -s $(which node) /opt/$KIBANA_NAME/node/bin/node \
    && mkdir -p /var/log/$KIBANA_NAME \
    && chown -RH kibana:kibana /opt/$KIBANA_NAME /var/log/$KIBANA_NAME \
    && echo "[i] Finishing" \
    && rm -rf /tmp/*.tar.gz /var/cache/apk/* \
    && echo "[i] Done"

# Add files
ADD scripts /scripts
COPY config/elasticsearch.yml /opt/elasticsearch/config/elasticsearch.yml
COPY config/kibana.yml /opt/kibana/config/kibana.yml
#ADD config/logstash.json /etc/$LOGSTASH_NAME/$LOGSTASH_NAME.json

### configure Logstash

# filters
#ADD config/01-lumberjack-input.conf     /etc/$LOGSTASH_NAME/conf.d
ADD config/02-beats-input.conf          /etc/$LOGSTASH_NAME/conf.d
ADD config/10-syslog.conf               /etc/$LOGSTASH_NAME/conf.d
ADD config/11-nginx.conf                /etc/$LOGSTASH_NAME/conf.d
ADD config/12-java.conf                 /etc/$LOGSTASH_NAME/conf.d
ADD config/14-rfc5424.conf              /etc/$LOGSTASH_NAME/conf.d
ADD config/30-output.conf               /etc/$LOGSTASH_NAME/conf.d

ADD config/logstash-beats.crt           /etc/$LOGSTASH_NAME/logstash-beats.crt
ADD config/logstash-beats.key           /etc/$LOGSTASH_NAME/logstash-beats.key

# patterns
ADD config/pattern_nginx.pattern        /opt/$LOGSTASH_NAME/patterns/nginx
ADD config/pattern_java.pattern         /opt/$LOGSTASH_NAME/patterns/java

# Specify Volume
VOLUME ["/var/lib/elasticsearch"]

# Exposes
EXPOSE 9200 9300 5601 514 514/udp 8080 5000 5044

# CMD
ENTRYPOINT ["/scripts/run.sh"]
