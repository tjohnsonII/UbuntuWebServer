# Use a lightweight base image with Python and Debian-based package support
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install required system packages
RUN apt-get update && apt-get install -y \
    nmap \
    sqlite3 \
    curl \
    iputils-ping \
    && apt-get clean

# Set working directory inside container
WORKDIR /app

# Copy all app files
COPY . /app

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Expose the Flask app port
EXPOSE 5000

# Run the web app
CMD ["python", "app.py"]
