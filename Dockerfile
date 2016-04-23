FROM darianss/myubuntu
MAINTAINER Darian Sastre-Stanescu <darian.sastre@gmail.com>

ENV PIO_VERSION 0.9.6
ENV SPARK_VERSION 1.6.0
ENV ELASTICSEARCH_VERSION 1.7.3
ENV HBASE_VERSION 1.1.2

ENV PIO_HOME /PredictionIO-${PIO_VERSION}
ENV PATH=${PIO_HOME}/bin:$PATH	
ENV JAVA_HOME /usr/

# RUN curl -O https://d8k1yxp8elc6b.cloudfront.net/PredictionIO-${PIO_VERSION}.tar.gz
ADD files/PredictionIO-0.9.6 /PredictionIO-0.9.6
RUN mkdir -p ${PIO_HOME}/vendors
# RUN tar -xvzf PredictionIO-${PIO_VERSION}.tar.gz -C / && mkdir -p ${PIO_HOME}/vendors
# RUN rm PredictionIO-${PIO_VERSION}.tar.gz
ADD files/pio-env.sh ${PIO_HOME}/conf/pio-env.sh

RUN curl -O http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop2.6.tgz
RUN tar -xvzf spark-${SPARK_VERSION}-bin-hadoop2.6.tgz -C ${PIO_HOME}/vendors
RUN rm spark-${SPARK_VERSION}-bin-hadoop2.6.tgz

# RUN curl -O https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz
# RUN tar -xvzf elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz -C ${PIO_HOME}/vendors
# RUN rm elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz
# RUN echo 'cluster.name: predictionio' >> ${PIO_HOME}/vendors/elasticsearch-${ELASTICSEARCH_VERSION}/config/elasticsearch.yml
# RUN echo 'network.host: 127.0.0.1' >> ${PIO_HOME}/vendors/elasticsearch-${ELASTICSEARCH_VERSION}/config/elasticsearch.yml

# RUN curl -O http://archive.apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz
# RUN tar -xvzf hbase-${HBASE_VERSION}-bin.tar.gz -C ${PIO_HOME}/vendors
# RUN rm hbase-${HBASE_VERSION}-bin.tar.gz
# ADD files/hbase-site.xml ${PIO_HOME}/vendors/hbase-${HBASE_VERSION}/conf/hbase-site.xml
# RUN sed -i "s|VAR_PIO_HOME|${PIO_HOME}|" ${PIO_HOME}/vendors/hbase-${HBASE_VERSION}/conf/hbase-site.xml
# RUN sed -i "s|VAR_HBASE_VERSION|${HBASE_VERSION}|" ${PIO_HOME}/vendors/hbase-${HBASE_VERSION}/conf/hbase-site.xml

RUN ${PIO_HOME}/sbt/sbt -batch

EXPOSE 7000
EXPOSE 8000

ADD ANOMALY /ANOMALY
ADD files/pio-start ${PIO_HOME}/bin
ADD files/pio-stop ${PIO_HOME}/bin
ADD files/run.sh /run.sh

# ENTRYPOINT /run.sh

RUN chmod +x /run.sh