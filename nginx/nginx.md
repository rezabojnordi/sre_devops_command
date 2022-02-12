# Nginx cheatsheet 

### Some usefull commands:
Reload configurations: `nginx -s reload`
Test configurations: `nginx -t`

### Config to force SSL:
```
server {
    listen       80;
    listen  [::]:80;
    server_name  -;
    return 301 https://$host$request_uri;
}

server {
    listen       443 ssl;
    listen  [::]:443;
    server_name  domain.co www.domain.co;
    ssl_certificate     /etc/letsencrypt/live/domain.co/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/domain.co/privkey.pem;
}
```
### Config multiple server blocks with the same SSL certificate:
```
ssl_certificate     /etc/letsencrypt/live/domain.co/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/domain.co/privkey.pem;

server {
    listen       443 ssl;
}

server {
    listen       443 ssl;
}

```

### Config a load balancer:
```
upstream test{
    server x.x.x.x:30008 max_fails=3 fail_timeout=30s;
    server x.x.x.x:30008 max_fails=3 fail_timeout=30s;
}

server {
    listen       80;
    server_name  domain.com;
    location / {
        proxy_pass http://test;
    }
}
```
### Config a tcp load balancer
```
stream {
    server {
        listen     80 tcp;
        proxy_pass www80;
    }
    server {
        listen     443 tcp;
        proxy_pass www443;
    }
    upstream www80 {
        server x.x.x.1:32080 max_fails=3 fail_timeout=30s;
        server x.x.x.2:32080 max_fails=3 fail_timeout=30s;
        server x.x.x.3:32080 max_fails=3 fail_timeout=30s;
    }
    upstream www443 {
        server x.x.x.1:32443 max_fails=3 fail_timeout=30s;
        server x.x.x.2:32443 max_fails=3 fail_timeout=30s;
        server x.x.x.3:32443 max_fails=3 fail_timeout=30s;
    }    
}
```

### Config to use reverse proxy:
```
server {
    listen       80;
    listen  [::]:80;
    server_name  domain.com;
    location / {
        proxy_pass          http://localhost:8080;
        proxy_http_version  1.1;
        proxy_set_header    Upgrade     $http_upgrade;
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```

### Config to load HTML:
```
server {
    listen       80;
    listen  [::]:80;
    server_name  domain.com;
    root /var/www/html;
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```

### Include configuration file:
```
server {
    includle physical_path;
}
```

### Nginx error codes:

```
map $status $status_text {
  400 'Bad Request';
  401 'Unauthorized';
  402 'Payment Required';
  403 'Forbidden';
  404 'Not Found';
  405 'Method Not Allowed';
  406 'Not Acceptable';
  407 'Proxy Authentication Required';
  408 'Request Timeout';
  409 'Conflict';
  410 'Gone';
  411 'Length Required';
  412 'Precondition Failed';
  413 'Payload Too Large';
  414 'URI Too Long';
  415 'Unsupported Media Type';
  416 'Range Not Satisfiable';
  417 'Expectation Failed';
  418 'I\'m a teapot';
  421 'Misdirected Request';
  422 'Unprocessable Entity';
  423 'Locked';
  424 'Failed Dependency';
  425 'Too Early';
  426 'Upgrade Required';
  428 'Precondition Required';
  429 'Too Many Requests';
  431 'Request Header Fields Too Large';
  451 'Unavailable For Legal Reasons';
  500 'Internal Server Error';
  501 'Not Implemented';
  502 'Bad Gateway';
  503 'Service Unavailable';
  504 'Gateway Timeout';
  505 'HTTP Version Not Supported';
  506 'Variant Also Negotiates';
  507 'Insufficient Storage';
  508 'Loop Detected';
  510 'Not Extended';
  511 'Network Authentication Required';
  default 'Something is wrong';
}
```

