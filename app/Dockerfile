# --- Build Stage ---
FROM python:3.11-slim AS builder

WORKDIR /app

# Install compilation dependencies if wheels aren't pre-built
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Layer caching: copy only requirements first
COPY requirements.txt .

# Install dependencies into a localized directory
RUN pip install --no-cache-dir --user -r requirements.txt


# --- Final Production Stage ---
FROM python:3.11-slim AS runner

WORKDIR /app

# Create a non-privileged system user for security hardening
RUN useradd -u 8888 appuser && chown -R appuser:appuser /app
USER appuser

# Copy installed packages from the builder stage
COPY --from=builder /root/.local /home/appuser/.local
COPY --from=builder /app /app

# Copy application source code
COPY --chown=appuser:appuser app.py .

# Ensure Python looks into the local user space for packages
ENV PATH=/home/appuser/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1

EXPOSE 5000

CMD ["python", "app.py"]
