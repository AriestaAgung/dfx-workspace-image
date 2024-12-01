FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive \
    RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH="/usr/local/cargo/bin:/usr/local/rustup/bin:/usr/local/bin:$PATH" \
    DFXVM_INIT_YES=true

# Update and install necessary dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg \
    ca-certificates \
    build-essential \
    git \
    libssl-dev \
    pkg-config \
    python3 \
    python3-pip \
    unzip \
    libcurl4 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Node.js (LTS) and npm
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Download and install the DFX SDK
RUN wget -qO dfx_install.sh https://sdk.dfinity.org/install.sh && \
    chmod +x dfx_install.sh && \
    /bin/bash dfx_install.sh -y < /dev/null && \
    rm -f dfx_install.sh

# Set up workspace directory
WORKDIR /workspace

# Add a non-root user (optional but recommended for security)
RUN useradd -m -s /bin/bash developer && \
    chown -R developer:developer /workspace
USER developer

# Default command to keep the container running
CMD ["bash"]
