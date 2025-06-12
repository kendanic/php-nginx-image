FROM ubuntu:24.04
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common curl zip unzip git supervisor \
    nginx php8.3-fpm php8.3-cli php8.3-curl php8.3-mysql \
    php8.3-mbstring php8.3-xml php8.3-zip php8.3-bcmath php8.3-gd \
    && mkdir -p /run/php \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Link NGINX logs to container stdout/stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Disable default NGINX site
RUN rm -f /etc/nginx/sites-enabled/default \
    && rm -f /etc/nginx/sites-available/default

# Replace NGINX global config with custom one
COPY nginx.conf /etc/nginx/nginx.conf

# copy index file for php config working 
COPY html/ /var/www/html/

# Replace PHP-FPM config
COPY php.ini /etc/php/8.3/fpm/php.ini

# Optional: Replace PHP-FPM pool config (for www pool tuning)
COPY www.conf /etc/php/8.3/fpm/pool.d/www.conf

# # Copy Supervisor configuration
# COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# # Entrypoint script
# COPY initial.sh /usr/bin/initial
# RUN chmod +x /usr/bin/initial

WORKDIR /var/www/html
EXPOSE 80

ENTRYPOINT ["/usr/bin/initial"]
