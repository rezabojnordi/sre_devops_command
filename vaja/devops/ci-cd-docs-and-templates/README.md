![GITLAB CI](https://imgs.search.brave.com/39g0-OMQNG8t7EdYd7XnpkXw0ZKKYjZ_mD1adSBSX8I/rs:fit:281:225:1/g:ce/aHR0cHM6Ly90c2Uz/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC5Z/ZU9sc1lqelhJY2o0/Wkw5UjNmYmRBQUFB/QSZwaWQ9QXBp)


# درباره

مباحث CI/CD در گیت لب مرحله بسیار مهمی میباشد. زیرا با پیاده سازی CI/CD شما دیگر به پیاده سازی دستی سروین ها ندارید و برنامه نویس ها میتوانند با استفاده از تنها یک کامنت در Branch ای که در آن فایل `**gitlab-ci.yml**` وجود داشته باشد برنامه خود را دیپلوی کرده و از آن استفاده کنند.

حالا ما میخواییم که فایل ها و متغیر هایی که در مراحل CI/CD استفاده کردیم رو مرحله به مرحله توضیح بدیم.

# فایل `gitlab-ci.yml`

با توجه به محتویات فایل ما که به این گونه است:

```yaml
variables:
 REGISTRY: "reg.vajab.ir:8443/library/"
 IMAGE: "walletm"
 TAG: "stage"

stages:
 - build
 - deploy
 - clean

build-job:
 stage: build
 script:
   - echo "Compiling the code..."
   # - rm -rf $CI_PROJECT_DIR
   - cd  $CI_PROJECT_DIR
   - git clone -b master git@git.vajab.ir:$CI_PROJECT_PATH

deploy-job:
 stage: deploy
 script:
   - cd  $CI_PROJECT_DIR
   - ansible-playbook -i invent.ini --extra-vars "registry=$REGISTRY image=$IMAGE tag=$TAG project_path=$CI_PROJECT_DIR project_name=$CI_PROJECT_NAME" run.yaml

clean-job: # This job runs in the build stage, which runs first.
 stage: clean
 script:
   - rm -rf $CI_PROJECT_DIR
```

میتوانیم بگوییم که CI/CD ما در ۳مرحله با استفاده از ۵ عدد متغیر تعریف می شود، که اول متغیر ها رو به صورت خلاصه توضیح داده و بعد مراحل و توضیحاتی درباره هر مرحله داده میشود.

## متغیر ها

* `Registry: `در این متغیر برای مسیر دهی به Docker Registry تنظیمات رو انجام میدهیم که دیگر نیازی نباشد که در تمامی قسمت هایی که Docker Registry رو استفاده میکنیم مسیر کامل رو جایگذاری کنیم. به صورت عادی ما از دامنه و مسیر `reg.vajab.ir:8443/library` برای Docker Registry استفاده میکنیم.
* `IMAGE:` در این قسمت ما اسم Image که سرویس در داخل آن Build گرفته می شود استفاده میکنیم. **نکته:** چونکه ما از Docker Registry شخصی استفاده میکنم برای تنظیم Image ها بسیار مهم است که اسم و تگ آن را به درستی وارد کنیم.
* `TAG:` همانطور که در مرحله قبل توضیح داده شد برای مشخص کردن اینکه هر Image، (برای مثال: برای چه مرحله ای، بر اساس کدام commit داخل گیت و…) ساخته شده است این قسمت حیاتی است. شما برای نمونه میتوانید از کلید های زیر برای متغیر Tag استفاده کنید:
    * `${CI_COMMIT_SHORT_SHA}` این متغیر به ما دسترسی استفاده از یک کد **41713ccb** برای اینکه TAG را تنظیم کنیم استفاده کنیم. توجه داشته باشید که این کد برای هر commit متمایز است.
* `$CI_PROJECT_DIR:` این متغیر برای این استفاده می شود که ما در (سرور/سیستم) ای که استفاده میکنیم و Gitlab-Runner در آن نصب است مسیردهی مناسب داشته باشیم. برای مثال در آخرین CI/CD ران شده مسیر ما این بوده: `/home/gitlab-runner/builds/HMpMx9AC/0/devops/test`
    * این متغیر یکی از متغیر های اصلی Gitlab است.
* `$CI_PROJECT_NAME:` این متغیر مانند متغیر بالا تنها برای اشاره کردن به اسم پروژه در داخل Gitlab است که برای مثال برای پروژه استفاده شده test است.
* `$CI_PROJECT_PATH:` این متغیر برای این است که ما بتوانیم در ‌Gitlab خود مسیر درست پروژه را پیدا کنیم در این مثال مسیر کامل ما https://git.vajab.ir:8586/devops/tes.git است.


## مراحل

### مرحله Build

در این مرحله ما پروژه را در پوشه ای که با توجه به متغیر $CI_PROJECT_DIR تنظیم شده است تنها Clone می کنیم.

### مرحله Deploy

در این مرحله ما با استفاده از فایل Ansible با نام run.yaml وجود دارد سرویس را پیاده سازی میکنیم که جلو تر فایل توضیح داده شده.

#### یک نکته بشدت مهم در این قسمت وجود دارد

شما زمانی که یک متغیر جدید و یا این که نام یک متغیر را عوض میکنید باید نیز متغیر ها رو در دستور 

```bash
ansible-playbook -i invent.ini --extra-vars "registry=$REGISTRY image=$IMAGE tag=$TAG project_path=$CI_PROJECT_DIR project_name=$CI_PROJECT_NAME" run.yaml
```

نیز تغییر دهید. توجه داشته باشید که تغییراتی که ایجاد میکنید باید در بخش --extra-vars داخل "" باشند

### مرحله Clean

در این مرحله تنها فایل های اضافی و پوشه هایی که با توجه به Clone گرفته شدن در مرحله اول حذف میشوند.

# فایل run.yaml

در این فایل که در مرحله Build قسمت CI/CD خود Gitlab انجام میشود، برای این است که ما توجه به راحتی استفاده از Ansible بتوانیم پروژه رو استارت کنیم.

محتوای فایل run.yaml به این صورت است:

```yaml
- hosts: test
 become: yes
 become_user: root
 tasks:
   - name: Build the image
     ansible.builtin.shell: cd "{{ project_path }}" && docker build -t '{{ registry }}{{ image }}:{{ tag }}' .
     register: build_image_out
     changed_when: build_image_out != 1
   - name: Push the image to registry
     ansible.builtin.shell: docker push '{{ registry }}{{ image }}:{{ tag }}'
     register: push_image
     changed_when: push_image != 1
   - name: Create Docker compose on Worker
     community.docker.docker_stack:
       name: '{{ project_name }}'
       state: present
       compose: '{{ project_path }}/docker-compose.yml'
       with_registry_auth: true
       resolve_image: always
     environment:
       IMAGE_NAME: "{{ registry }}{{ image }}"
       IMAGE_TAG: "{{ tag }}"
```

دو مرحله داریم: 

1. در مرحله اول Image پروژه ما با توجه به متغیر های تنظیم شده ساخته میشود.
2. پروژه ما با استفاده از ماژول docker_stack در Ansible پیاده سازی میشود.

## مرحله ۱

در این قسمت همانطور که مشاهده میکنید از متغیر های:

* `Project_path`
* `registry`
* `image`
* `Tag`

استفاده میکنیم. که در بخش قبلی توضیح داده شده اند.

## مرحله ۲

در این مرحله دو متغیر اول حالت ثابت باقی بماند مگر این که در اسم آنها تغییری ایجاد شده باشد. در قسمت environments توجه داشته باشید که ما در داخل فایل docker-compose.yml خود نیز از متغیر هایی که در قسمت environments استفاده شده اند نیز استفاده میکنیم.

# فایل Docker-compose.yml

```yaml
version: "3.8"
services:
 walletm:
   image: ${IMAGE_NAME}:${IMAGE_TAG}
   deploy:
     placement:
       constraints:
         - node.role == worker
     restart_policy:
       condition: on-failure
       delay: 5s
       max_attempts: 3
     labels:
       - "traefik.enable=true"
       - "traefik.http.routers.walletm.entrypoints=web"
       - "traefik.http.routers.walletm.rule=Host(`test.wallet.com`)"
       - "traefik.http.services.walletm.loadbalancer.server.port=80"
       - "traefik.default.protocol=http"
       - "traefik.http.routers.walletm.service=walletm"
       - "traefik.docker.network=application"
   environment:
     CURRENCY: "MULTI CURRENCY (BTC, SHIB, USDT, XRP, ETH, SINA)"
     DB_URI: "db-walletm"
     DB_NAME: "wallet_db"
     DB_USER: "root"
     DB_PASSWORD: "root"
     DB_PORT: "5432"
   depends_on:
     - "db-walletm"
   networks:
     - application

 db-walletm:
   image: postgres
   environment:
     POSTGRES_USER: root
     POSTGRES_PASSWORD: root
     POSTGRES_DB: wallet_db
   deploy:
     placement:
       constraints:
         - node.role == worker
   healthcheck:
     test: ["CMD", "pg_isready", "-q", "-d", "wallet_db", "-U", "root"]
     timeout: 45s
     interval: 10s
     retries: 3
   volumes:
     - walletm_pgdata:/var/lib/postgresql/data
   networks:
     - application
volumes:
 walletm_pgdata:
   driver: convoy

networks:
 application:
   external: true
```

در حال حاضر از تنها متغیر هایی که در داخل docker-compose.yml خود استفاده میکنیم در این بخش هستند.

```yaml
…
walletm:
   image: ${IMAGE_NAME}:${IMAGE_TAG}
…
```

که در بخش اول این داکیومنت توضیحات لازم داده شده است.
