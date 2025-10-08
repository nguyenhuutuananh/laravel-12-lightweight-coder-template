# Use Ubuntu with PHP pre-installed (more reliable)
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Ho_Chi_Minh

# Install PHP 8.2 and essential packages
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php -y && \
    apt-get update && \
    apt-get install -y \
        php8.2-cli \
        php8.2-zip \
        php8.2-sqlite3 \
        php8.2-curl \
        php8.2-mbstring \
        php8.2-xml \
        php8.2-dom \
        curl \
        git \
        unzip \
        zip \
        sudo \
        sqlite3 \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20.x
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Create user
ARG USER=coder
RUN useradd --create-home --shell /bin/bash ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER}

# Switch to user
USER ${USER}
WORKDIR /home/${USER}

# Install Laravel installer
RUN composer global require laravel/installer

# Add Composer global bin to PATH
ENV PATH="/home/${USER}/.composer/vendor/bin:${PATH}"

# Set up code-server config
RUN mkdir -p /home/${USER}/.config/code-server
COPY --chown=${USER}:${USER} config.yaml /home/${USER}/.config/code-server/

# Create workspace directory
RUN mkdir -p /home/${USER}/workspace

# Expose ports
EXPOSE 8000 13337

# Start code-server
CMD ["code-server", "--bind-addr", "0.0.0.0:13337", "/home/coder/workspace"]
