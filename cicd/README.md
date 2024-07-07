# Cicd



<img src="img/1-.png" height="200" width="700" style="float:center" ></img>


<img src="img/2.png" height="500" width="700" style="float:center" ></img>

<img src="img/3.png" height="500" width="300" style="float:center" ></img>

<img src="img/5.png" height="100" width="500" style="float:center" ></img>



## installing gitlab-runner
```
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
sudo apt-get install gitlab-runner
```

## or install with shell
```
# Download the binary For Debian/Ubuntu/Mint:
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
#For RHEL/CentOS/Fedora
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh" | sudo bash

# Give it permission to execute
sudo chmod +x /usr/local/bin/gitlab-runner

# Create a GitLab Runner user
sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash

# Install and run as a service
sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner

echo  -e 'gitlab-runner\tALL=(ALL)\tNOPASSWD:\tALL' > /etc/sudoers.d/gitlab-runner

sudo gitlab-runner start

```


## adding config in gitlab-runner

```
vim /etc/gitlab-runner/config.toml
```

```
concurrent = 4
check_interval = 0
 
[session_server]
  session_timeout = 1800
 
[[runners]]
  name = "cicd"
  url = "https://cicd.softgrand.ir/"
  token = "ZAqdYWrEKHB1T7zNTjz1"
  executor = "docker"
  [runners.custom_build_dir]
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]
    [runners.cache.azure]
  [runners.docker]
    tls_verify = false
    #image = "alpine"
    image = "cicd:1"
    privileged = true
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/cache","/var/run/docker.sock:/var/run/docker.sock"]
    shm_size = 0
    pull_policy = "if-not-present"

```

## customming docker image for gitlab-ruuner

```

FROM alpine:latest
LABEL maintainer="Vivek Gite webmater@cyberciti.biz"
RUN apk add --update --no-cache openssh  python3 py3-pip openssl ca-certificates sshpass openssh-client rsync git && \
    apk --no-cache add --virtual build-dependencies python3-dev libffi-dev musl-dev gcc cargo openssl-dev libressl-dev build-base && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_configi && \
    adduser -h /home/reza -s /bin/sh -D reza && \
    pip3 install --upgrade pip wheel && \
    pip3 install --upgrade cryptography cffi && \
    pip3 install ansible-core ansible && \
    pip3 install mitogen ansible-lint jmespath && \
    pip3 install --upgrade pywinrm && \
    apk del build-dependencies && \
    echo -n 'reza:reza@123' | chpasswd && \
    mkdir -p /home/reza/.ssh && chmod 700 /home/reza/.ssh && chown reza:reza /home/reza/.ssh 
COPY ./key/* /home/reza/.ssh/
RUN export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa"
#COPY ./entrypoint.sh /entrypoint.sh
#RUN chmod +x entrypoint.sh
#ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 22
#COPY entrypoint.sh /

```

## adding entrypoint
```

#!/bin/sh
ssh-keygen -A
exec /usr/sbin/sshd -D -e "$@"

```

## adding rule in gitlab-ci

```
vim .gitlab-ci.yml
```
```
stages:          # List of stages for jobs, and their order of execution
  - build
  - test
  - deploy
 
 
build-job:       # This job runs in the build stage, which runs first.
  stage: build
  script:
    - echo "Compiling the code..."
    - echo "Compile complete."
    - export ANSIBLE_HOST_KEY_CHECKING=False
    - rm -rf cicd
    #- git clone -b dev https://root:09368700813@cicd.softgrand.ir/root/cicd.git
    - git clone -b dev https://root@cicd.softgrand.ir/root/cicd.git
    - cd ./cicd/
    - ansible-playbook -i inventory syscl.yml
 
 
 
unit-test-job:   # This job runs in the test stage.
  stage: test    # It only starts when the job in the build stage completes successfully.
  script:
    - echo "Running unit tests... This will take about 60 seconds."
    - sleep 40
    - echo "Code coverage is 90%"
 
 
lint-test-job:   # This job also runs in the test stage.
  stage: test    # It can run at the same time as unit-test-job (in parallel).
  script:
    - echo "Linting code... This will take about 10 seconds."
    - sleep 10
    - echo "No lint issues found."
 
 
deploy-job:      # This job runs in the deploy stage.
  stage: deploy  # It only runs when *both* jobs in the test stage complete successfully.
  script:
    - echo "Deploying application..."
    - echo "Application successfully deployed."

```

## sample more than 1 stage

```
stages:
  - init
  - build
  - run
  - run-deploy

init-project-deploy:
  stage: init
  tags:
    - deploy 
  script:
  - hostname
  - cd /home/gitlab-runner
  - pwd
  - sudo rm -rf * && git clone ssh://git@cicd.softgrand.ir:3031/mrm/cinder.git
  
  
build-project-deploy:
  stage: build
  tags:
    - deploy
  script:
  - cd /home/gitlab-runner
  - pwd
  - ls -lah
  - cd /home/gitlab-runner/cinder
  - pwd
  - ls -lah


run-project-deploy:
  stage: run-deploy
  tags:
    - deploy
  script:
  - cd /home/gitlab-runner/cinder
  - sudo ansible-playbook playbook.yml
```

## How to configure ci cd for dependence 

```
stages:
  - init
  - build
  - run
  - run-deploy
  
init-project-test:
  stage: init
  tags:
    - test 
  script:
  - hostname
  - pwd
  - sudo chown gitlab-runner:root /home/app  
  - sudo chown gitlab-runner:root /var/www/html
  - cd /home/gitlab-runner
  - pwd
  - sudo rm -rf * && git clone ssh://git@cicd.softgrand.ir:3031/mrm/nginx.git

init-project-deploy:
  stage: init
  tags:
    - deploy 
  script:
  - hostname
  - pwd
  - sudo chown gitlab-runner:root /home/app  
  - sudo chown gitlab-runner:root /var/www/html
  - cd /home/gitlab-runner
  - pwd
  - sudo rm -rf * && git clone ssh://git@cicd.softgrand.ir:3031/mrm/nginx.git
  
  
build-project-test:
  stage: build
  tags:
    - test  
  script:
  - cd /var/www/html
  - pwd
  - sudo rm -rf *
  - cd /home/gitlab-runner/nginx
  - pwd
  - ls -lah
  - cp index.html /var/www/html
  
build-project-deploy:
  stage: build
  tags:
    - deploy
  script:
  - cd /var/www/html
  - pwd
  - sudo rm -rf *
  - cd /home/gitlab-runner/nginx
  - pwd
  - ls -lah
  - cp index_2.html /var/www/html/index.html


run-project-test:
  stage: run
  tags:
    - test
  script:
  - sudo service nginx restart
  - sudo nginx -t
  - sudo service nginx status

run-project-deploy:
  stage: run-deploy
  tags:
    - deploy
  needs:  ["run-project-test"]
  script:
  - sudo service nginx restart
  - sudo nginx -t
  - sudo service nginx status

```
