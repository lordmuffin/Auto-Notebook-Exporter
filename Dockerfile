FROM python:3.10-slim

# Install system dependencies for Chrome and undetected-chromedriver
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    xvfb \
    libnss3 \
    libfontconfig1 \
    libxi6 \
    libxcursor1 \
    libxss1 \
    libxcomposite1 \
    libasound2 \
    libxdamage1 \
    libxtst6 \
    libatk1.0-0 \
    libgtk-3-0 \
    libdrm2 \
    libgbm1 \
    && rm -rf /var/lib/apt/lists/*

# Set up staging area
WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Create volume mount point for persistent data
RUN mkdir -p /auth_data
VOLUME /auth_data

# Create directory for input and output
RUN mkdir -p /input /output

# Copy application code
COPY migration_assistant.py .

# Set environment variables to encourage headless operation where possible (though uc needs help)
ENV PYTHONUNBUFFERED=1
ENV DISPLAY=:99

CMD ["python", "migration_assistant.py"]
