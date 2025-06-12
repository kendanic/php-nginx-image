# php-nginx-image
For complete DevOps Docker image documentation for building a self-contained PHP-FPM + NGINX image using Ubuntu, Supervisor, and baked-in configs


```cmd
docker build -t php-nginx-image/php-nginx:8.1 .
docker push php-nginx-image/php-nginx:8.1
```



docker build -t kendanic/php-nginx:8.4 .


cat /var/log/supervisor/supervisord.log

supervisorctl status


ps aux | grep php
ps aux | grep nginx
