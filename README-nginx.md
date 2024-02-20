# Install Nginx

```
apt install nginx
```

## Enable SSL

```
sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt
```

## Enable index browsing
```
autoindex on;
```

/etc/nginx/conf.d/ssl.conf
```
server {
    listen 443;
    listen [::]:443;
    ssl on;
    ssl_certificate_key /etc/nginx/ssl/server.key;
    ssl_certificate /etc/nginx/ssl/server.crt;
    #ssl_certificate /etc/nginx/ssl/b_certf.crt;

    root /var/www/html;
    autoindex on;

    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
            try_files $uri $uri/ =404;
    }
}
```

## Enable Basic Auth

Reference: https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-http-basic-authentication/

```
htpasswd -c ssl/htpasswd foo
```

