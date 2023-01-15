# install gitlab on server

```
sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl

sudo apt-get install -y postfix


curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash

sudo EXTERNAL_URL="https://gitlab.example.com" apt-get install gitlab-ce
```

# Update Gitlab Version
```
curl -s https://packages.gitlab.com/gpg.key | apt-key add -
```
```
apt update && apt dist-upgrade
```
```
gitlab-rake gitlab:env:info
```
```
sudo touch /etc/gitlab/skip-auto-reconfigure
```
```
apt-cache policy gitlab-ce | grep 14.6
```
```
apt install gitlab-ce=14.6.7-ce.0
```
```
sudo SKIP_POST_DEPLOYMENT_MIGRATIONS=true gitlab-ctl reconfigure
```
```
sudo gitlab-rake db:migrate
```
```
sudo gitlab-ctl hup puma
sudo gitlab-ctl restart sidekiq
```

# Gitlab cheatsheet 

### How to reset root password?
First start Rails console and it takes a few minutes:
```
gitlab-rails console
```
In console put these commands:
```
user = User.find_by_username 'root'
user.password = 'secret_pass'
user.password_confirmation = 'secret_pass'
user.send_only_admin_changed_your_password_notification!
user.save!
```
More info here: https://docs.gitlab.com/ce/security/reset_user_password.html#reset-your-root-password

If you change ssh port for gitlab, you will get this error when trying to clone from ssh:
```
ssh: connect to host git.greenrnd.com port 22: Connection refused
```
Solve this error by creating a file in your local pc `~/.ssh/config` and add:
```
Host git.domain.com
    User git
    Hostname git.domain.com
    Port 2580
```



