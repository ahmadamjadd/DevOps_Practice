FROM ubuntu

RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set default Python alias
RUN ln -s /usr/bin/python3 /usr/bin/python

# Set working directory inside the container
WORKDIR /app

# Default command to run Python
CMD ["python"]
