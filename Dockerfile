FROM bitnami/spark:3.5-debian-12 as builder  

USER root

# Install build dependencies
RUN install_packages python3-dev gcc build-essential --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*


# Create venv with permission
# RUN mkdir -p /opt/venv && chown 1001:1001 /opt/venv 
# USER 1001

# Setup virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# install Python packages
#COPY --chown=1001:1001 requirements.txt .
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && \
    rm -rf /root/.cache/pip

# Runtime stage
FROM bitnami/spark:3.5-debian-12

# Copy virtualenv and configs
USER root
COPY --from=builder /opt/venv /opt/venv
COPY --chown=1001:1001 scripts/entrypoint.sh /entrypoint.sh

#COPY --from=builder --chown=1001:1001 /opt/venv /opt/venv
# COPY --from=builder /opt/bitnami/spark/venv /opt/bitnami/spark/venv
# COPY --chown=1001:1001 config/spark-defaults.conf ${SPARK_HOME}/conf/
#COPY --chown=1001:1001 scripts/entrypoint.sh /entrypoint.sh

# cleanup 
RUN chmod +x /entrypoint.sh && \
    #find /opt/bitnami/spark -type d -name '__pycache__' -exec rm -rf {} + && \
    find /opt/venv -type d -name '__pycache__' -exec rm -rf {} + && \
    #rm -rf /opt/bitnami/spark/examples
    chown -R 1001:1001 /opt/venv

# final setup
USER 1001
ENV PATH="/opt/venv/bin:$PATH"
ENTRYPOINT [ "/entrypoint.sh" ]
