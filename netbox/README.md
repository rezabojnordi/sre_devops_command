# netbox service

### Install PostgreSQL.

```
sudo apt install postgresql libpq-dev -y

sudo systemctl start postgresql

sudo systemctl enable postgresql

sudo passwd postgres

su - postgres

psql

CREATE DATABASE netbox;

CREATE USER netbox WITH ENCRYPTED password 'my_strong_password';

GRANT ALL PRIVILEGES ON DATABASE netbox to netbox;

\q

exit





```


## Install Redis

```
sudo apt install -y redis-server

```

## Install and configure NetBox

```
sudo apt install python3 python3-pip python3-venv python3-dev build-essential libxml2-dev libxslt1-dev libffi-dev libpq-dev libssl-dev zlib1g-dev git -y

sudo pip3 install --upgrade pip

sudo mkdir -p /opt/netbox/ && cd /opt/netbox/

sudo git clone -b master https://github.com/netbox-community/netbox.git .

sudo adduser --system --group netbox

sudo chown --recursive netbox /opt/netbox/netbox/media/

cd /opt/netbox/netbox/netbox/

sudo cp configuration.example.py configuration.py

sudo ln -s /usr/bin/python3 /usr/bin/python

sudo /opt/netbox/netbox/generate_secret_key.py

for example : -^%YEl*Q2etCR6$kNG70H=&sM(45XvJaBWdf3O)inZ@L9j8_w1

sudo nano /opt/netbox/netbox/netbox/configuration.py

```

```
ALLOWED_HOSTS = ['*']

DATABASE = {
    'NAME': 'netbox',                           # Database name you created
    'USER': 'netbox',                           # PostgreSQL username you created
    'PASSWORD': 'my_strong_password',           # PostgreSQL password you set
    'HOST': 'localhost',                        # Database server
    'PORT': '',                                 # Database port (leave blank for default)
}

SECRET_KEY = '-^%YEl*Q2etCR6$kNG70H=&sM(45XvJaBWdf3O)inZ@L9j8_w1'
```

```
sudo /opt/netbox/upgrade.sh
```

```
source /opt/netbox/venv/bin/activate

```
### Go to /opt/netbox/netbox directory.

```
cd /opt/netbox/netbox

python3 manage.py createsuperuser

sudo reboot
```

## Configure Gunicorn

### Copy /opt/netbox/contrib/gunicorn.py to /opt/netbox/gunicorn.py.

```
sudo cp /opt/netbox/contrib/gunicorn.py /opt/netbox/gunicorn.py
```

## Configure Systemd

### Copy contrib/netbox.service and contrib/netbox-rq.service to the /etc/systemd/system/ directory.
```
sudo cp /opt/netbox/contrib/*.service /etc/systemd/system/

sudo systemctl daemon-reload

sudo systemctl start netbox netbox-rq


```

# Configure Nginx Web Server

```
sudo apt install -y nginx

sudo cp /opt/netbox/contrib/nginx.conf /etc/nginx/sites-available/netbox

sudo vim /etc/nginx/sites-available/netbox
```

## Replace all the files content with the bellow code. Modify the server_name value with your server IP address

```
server {
    listen 80;

    # CHANGE THIS TO YOUR SERVER'S NAME
    server_name 192.0.2.10;

    client_max_body_size 25m;

    location /static/ {
        alias /opt/netbox/netbox/static/;
    }

    location / {
        proxy_pass http://127.0.0.1:8001;
        proxy_set_header X-Forwarded-Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

```

### Delete /etc/nginx/sites-enabled/default

```
sudo rm /etc/nginx/sites-enabled/default

sudo ln -s /etc/nginx/sites-available/netbox /etc/nginx/sites-enabled/netbox

sudo systemctl restart nginx
```

