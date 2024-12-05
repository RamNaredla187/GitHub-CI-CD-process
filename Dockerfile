From apache/age
# Install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    postgresql-server-dev-all \
    && rm -rf /var/lib/apt/lists/*
# Clone the pgvector repository
WORKDIR /tmp
RUN git clone https://github.com/pgvector/pgvector.git
# Build and install pgvector
WORKDIR /tmp/pgvector
RUN make
RUN make install
# Expose PostgreSQL port
EXPOSE 5432
