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



