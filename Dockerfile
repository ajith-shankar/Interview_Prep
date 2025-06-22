FROM openjdk:11-jre-slim

ENV SPARK_VERSION=3.5.0 \
    HADOOP_VERSION=3 \
    SPARK_HOME=/opt/spark

# Install only essential dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Download and extract Spark
RUN curl -fsSL https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz | \
    tar -xz -C /opt && \
    mv /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} ${SPARK_HOME} && \
    rm -rf ${SPARK_HOME}/examples ${SPARK_HOME}/jars/spark-examples*.jar

ENV PATH="${SPARK_HOME}/bin:${PATH}"

# Copy log4j.properties to Spark config directory to suppress logs
COPY config/log4j.properties ${SPARK_HOME}/conf/log4j.properties

# Copy only necessary files
COPY scripts/ /scripts/
COPY requirements.txt /tmp/requirements.txt

RUN pip3 install --no-cache-dir -r /tmp/requirements.txt && \
    rm -rf /root/.cache

RUN chmod +x /scripts/entrypoint.sh

ENTRYPOINT ["/scripts/entrypoint.sh"]