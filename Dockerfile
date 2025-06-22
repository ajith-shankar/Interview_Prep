# Stage 1: Builder - Use the same base image to ensure compatibility
FROM bitnami/spark:3.5 as builder

USER root

# Install build dependencies
RUN install_packages python3-dev gcc build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Python packages
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && \
    rm -rf /root/.cache/pip

# Clean Python cache
RUN find /opt/venv -type d -name '__pycache__' -exec rm -rf {} +

# Stage 2: Runtime - Minimal image
FROM bitnami/spark:3.5

# Install only runtime dependencies
USER root
RUN install_packages libgomp1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy virtual environment
COPY --from=builder /opt/venv /opt/venv

# Clean Spark installation
RUN rm -rf \
    /opt/bitnami/spark/examples \
    /opt/bitnami/spark/jars/*-sources.jar \
    /opt/bitnami/spark/jars/*-javadoc.jar \
    /opt/bitnami/spark/python/test

# Copy entrypoint
COPY --chown=1001:1001 scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Final setup
USER 1001
ENV PATH="/opt/venv/bin:$PATH"
ENTRYPOINT ["/entrypoint.sh"]