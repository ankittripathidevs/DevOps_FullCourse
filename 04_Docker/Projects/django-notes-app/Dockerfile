# ============================================================
# Django Backend - Dockerfile
# ============================================================

# Setp:1  Use a lightweight and modern Python image
FROM python:3.9-slim

# Step:2  Set the working directory inside the container
WORKDIR /app/backend


# ============================================================
# Install System Dependencies
# ============================================================

# Setp:3  Install packages required to build/install Python dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    default-libmysqlclient-dev \
    pkg-config \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*


# ============================================================
# Install Python Dependencies
# ============================================================

# Step:4  Copy requirements first
COPY requirements.txt .

# Setp:5   Install Python dependencies without keeping pip's cache
RUN pip install --no-cache-dir -r requirements.txt


# ============================================================
# Copy Application
# ============================================================

# Step:6  Copy the Django project into the container
COPY . .


# ============================================================
# Django Server
# ============================================================

# Step:7  Django development server listens on port 8000
EXPOSE 8000

# Setp:8  Start Django and allow connections from outside the container
# CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
