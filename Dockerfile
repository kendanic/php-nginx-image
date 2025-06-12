FROM ubuntu:20.04

LABEL maintainer="Mayur Shingrakhiya <mk.shingrakhiya@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install PHP, NGINX, Supervisor, and tools
RUN apt-get update && apt-get install -y \
    software-properties-common curl zip unzip git supervisor \
    nginx php8.1-fpm php8.1-cli php8.1-curl php8.1-mysql \
    php8.1-mbstring php8.1-xml php8.1-zip php8.1-bcmath php8.1-gd \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    && mkdir /run/php \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Link NGINX logs to Docker stdout/stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Remove default NGINX config and enable custom one
RUN rm -f /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx/sites-available/custom.conf
RUN ln -s /etc/nginx/sites-available/custom.conf /etc/nginx/sites-enabled/custom.conf

# Add PHP config
COPY php.ini /etc/php/8.1/fpm/php.ini
COPY php.ini /etc/php/8.1/cli/php.ini
COPY www.conf /etc/php/8.1/fpm/pool.d/www.conf

# Add Supervisor config and entrypoint script
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY initial.sh /usr/bin/initial
RUN chmod +x /usr/bin/initial

WORKDIR /var/www/html

EXPOSE 80

ENTRYPOINT ["/usr/bin/initial"]
