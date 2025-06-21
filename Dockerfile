FROM bitnami/spark:3.5-debian-12 as builder  

USER root

# # Install additional packages
# RUN mkdir -p /var/lib/apt/lists/partial && \
#     apt-get update && \
#     apt-get install -y --no-install-recommends \
#         python3-dev \
#         gcc \
#         build-essential && \
#     rm -rf /var/lib/apt/lists/*

# Install build dependencies
RUN install_packages python3-dev gcc build-essential


# Create venv with permission
RUN mkdir -p /opt/venv && chown 1001:1001 /opt/venv 
USER 1001

# Setup virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# install Python packages
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt 

# Runtime stage
FROM bitnami/spark:3.5-debian-12

# Copy virtualenv and configs
COPY --from=builder /opt/venv /opt/venv
COPY --from=builder /opt/bitnami/spark/venv /opt/bitnami/spark/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY config/spark-defaults.conf ${SPARK_HOME}/conf/
COPY scripts/entrypoint.sh /entrypoint.sh
RUN chown 1001:1001 chmod +x /entrypoint.sh

USER 1001

ENTRYPOINT [ "/entrypoint.sh" ]
