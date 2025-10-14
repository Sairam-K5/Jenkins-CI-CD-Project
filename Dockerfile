# Use a Python base image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies for Python and PostgreSQL (if needed)
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-setuptools \
    python3-venv \
    build-essential \
    libpq-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy dependency list first for caching efficie
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Run migrations after copying source
RUN python manage.py migrate

# Expose Django port
EXPOSE 8000

# Start the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]


