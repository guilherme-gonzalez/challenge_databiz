# Use the official Apache Airflow image as the base image
#docker build -t airflow-pyspark:latest .
FROM apache/airflow:2.6.3-python3.10

# Switch to root user to install additional packages
USER root

# Install Java (required for Spark)
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk && \
    apt-get clean

# Set JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Download and install Apache Spark
ARG SPARK_VERSION=3.4.1
RUN curl -fsSL https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz | tar -xz -C /opt/ && \
    mv /opt/spark-${SPARK_VERSION}-bin-hadoop3 /opt/spark && \
    chown -R airflow /opt/spark

# Set SPARK_HOME environment variable
ENV SPARK_HOME=/opt/spark
ENV PATH=$SPARK_HOME/bin:$PATH

# Switch back to airflow user
USER airflow

# Install PySpark
RUN pip install pyspark==${SPARK_VERSION}

# Copy your Airflow DAGs and configuration
COPY dags /opt/airflow/dags/
COPY airflow.cfg /opt/airflow/airflow.cfg

# Set entrypoint
ENTRYPOINT ["/entrypoint"]

# Default command
CMD ["webserver"]

