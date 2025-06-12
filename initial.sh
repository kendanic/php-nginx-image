[supervisord]
nodaemon=true

[program:nginx]
command=/usr/sbin/nginx -g "daemon off;"
stdout_logfile=/dev/stdout
stderr_logfile=/dev/stderr

[program:php-fpm]
command=/usr/sbin/php-fpm8.1 -F
stdout_logfile=/dev/stdout
stderr_logfile=/dev/stderr
