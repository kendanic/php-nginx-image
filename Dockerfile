FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install PHP-FPM and NGINX
RUN apt-get update && \
    apt-get install -y php8.3-fpm nginx curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy website files
COPY index.php /var/www/html/

# Copy NGINX server block
COPY default.conf /etc/nginx/conf.d/default.conf

# Remove default nginx.conf and replace with minimal one
RUN rm /etc/nginx/nginx.conf && echo "\
user www-data;\n\
worker_processes auto;\n\
pid /run/nginx.pid;\n\
events { worker_connections 1024; }\n\
http {\n\
    include       mime.types;\n\
    default_type  application/octet-stream;\n\
    sendfile        on;\n\
    keepalive_timeout 65;\n\
    include /etc/nginx/conf.d/*.conf;\n\
}" > /etc/nginx/nginx.conf

# Copy and set startup script
COPY start.sh /usr/bin/start.sh
RUN chmod +x /usr/bin/start.sh

# Expose port
EXPOSE 80

# Command to run both services
CMD ["/usr/bin/start.sh"]
CMD php-fpm8.3 -F & nginx -g 'daemon off;'
CMD bash -c "php-fpm8.3 -F & nginx -g 'daemon off;'"
