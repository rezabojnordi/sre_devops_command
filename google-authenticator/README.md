
# Google Authenticator Turn on 2-Step Verification
When you enable 2-Step Verification (also known as two-factor authentication), you add an extra layer of security to your account. You sign in with something you know (your password) and something you have (a code sent to your phone).your phone.

## Steup Google Authenticator
### Install package

```
sudo apt-get update
```
```
sudo apt-get install libpam-google-authenticator
```

### Setting Pam

into file
```
/etc/pam.d/sshd
```
comment it
```
#@include common-auth
```
and add blew:
```
@include common-password
auth required pam_google_authenticator.so nullok
auth required pam_permit.so
```

### Setting SSHD
into file
```
/etc/ssh/sshd_config
```
```
PasswordAuthentication no
ChallengeResponseAuthentication yes
AuthenticationMethods publickey,keyboard-interactive
```

#### Authentication Methods
adding end of sshd confige file 
```
publickey,keyboard-interactive
```

### Enable 2FA
```
su user
google-authenticator
Do you want authentication tokens to be time-based (y/n) y
Do you want me to update your"~/.google_authenticator" file (y/n) y
Do you want to disallow multiple uses of the same authentication
token? This restricts you to one login about every 30s, but it increases
your chances to noticeor even prevent man-in-the-middle attacks (y/n) y
Bydefault, anew token is generated every 30 seconds by the mobile app. In order to compensatefor possible time-skew between the clientand the server, we allow an extra token beforeand after the current time. This allowsfor a time skew of up to 30 seconds between the authentication serverand client. Suppose you experience problems with poor time synchronization. In thatcase, you can increase the window from itsdefault size of 3 permitted codes (one previous code, the current code, the next code) to 17 permitted codes (the eight previous codes, the current code,and the eight next codes). This will permit a time skew of up to 4 minutes between clientand server.
Do you want todo so? (y/n) y

If the computer that you are logging into isn't hardened against brute-force
login attempts, you can enable rate-limitingfor the authentication module.
Bydefault, this limits attackers to no more than three login attempts every 30s.
Do you want to enable rate-limiting (y/n) y

```
