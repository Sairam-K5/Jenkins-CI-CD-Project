# STEP 1: Use an official Python image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# STEP 2: Install dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# STEP 3: Copy source code
COPY . /app/

# STEP 4: Collect static files (optional)
RUN python manage.py collectstatic --noinput || true

# STEP 5: Expose port & start app
EXPOSE 8000

# Use gunicorn as production server
CMD ["gunicorn", "myproject.wsgi:application", "--bind", "0.0.0.0:8000"]
