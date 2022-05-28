# Installation of wordpress on nginx 

When creating a Mysql user, You should change the password authentication plugin to: `Native Mysql Authentication`
Database host name is: `mysql_docker_container_name`


### Set the owner to www-data:
```
chown -R www-data:www-data path_to_website_root
```

### If needed set permissions:
```
find . -type f -exec chmod 644 {} \;
find . -type d -exec chmod 755 {} \; 
```

### nginx config to put your wordpress in: domain.com/wordpress
```
location /wordpress {
        index  index.php;
        try_files $uri $uri/ /wordpress/index.php?q=$request_uri;
        #try_files $uri /index.php?$args;
    }
```
#### Add this for php support:
```
location ~ .php$ {
            try_files $uri =404;
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
}
```
#### Increase max upload size:
```
vim /etc/php/7.3/fpm/php.ini
```
Change these valuse as you want:
```
post_max_size = 128M
upload_max_filesize = 128M
```
Then:
```
service php7.3-fpm restart
```

