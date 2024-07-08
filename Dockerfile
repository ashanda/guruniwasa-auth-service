# Use the official PHP image as the base image
FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    locales \
    zip \
    unzip \
    libzip-dev \
    supervisor \
    libevent-dev \
    nginx \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql zip exif pcntl
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Swoole extension
RUN pecl install swoole
RUN docker-php-ext-enable swoole

# Copy existing application directory contents
COPY . .

# Expose port 9000 for Octane
EXPOSE 9000

# Start Octane server
CMD ["php", "artisan", "octane:start", "--server=swoole", "--host=0.0.0.0", "--port=9000"]
