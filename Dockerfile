# Use a minimal Python base image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies (only what’s needed)
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency list first for caching efficiency
COPY requirements.txt .

# Install dependencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Create a non-root user
RUN useradd -m appuser
USER appuser

# Expose Django port
EXPOSE 8000

# Command to start the app (development)
# For production, use: gunicorn your_project_name.wsgi:application --bind 0.0.0.0:8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
