# درباره

---

Convoy یک افزونه برای volume های Docker برای انواع پشتیبان های ذخیره سازی است. این برنامه افزودنی های خاص فروشنده مانند عکس های فوری، پشتیبان گیری و بازیابی را پشتیبانی می کند. این در Go نوشته شده است و می تواند به عنوان یک باینری مستقل مستقر شود.

## چرا از Convoy استفاده کنیم؟

Convoy مدیریت داده های خود را در Docker آسان می کند. حجم‌های ثابتی را برای کانتینرهای Docker با پشتیبانی از عکس‌های فوری، پشتیبان‌گیری و بازیابی در قسمت‌های مختلف پشتیبان (مانند نقشه‌بردار دستگاه، NFS، EBS) فراهم می‌کند.

به عنوان مثال، شما می توانید:

* volume ها را بین هاست ها مهاجرت کنید
* volume های یکسان را در بین هاست ها به اشتراک بگذارید
* زمان‌بندی کردن snapshot های دوره‌ای از volume ها
* یک volume را از backup قبلی بازیابی کنید

### Backend هایی که پشتیبانی میشوند

* Device Mapper
* Virtual File System (VFS) / Network File System (NFS)
* Amazon Elastic Block Store (EBS)

# روش نصب و راه اندازی

---

شما میتوانید با استفاده از دستور زیر Convoy را دانلود کرده

``` bash
wget -c https://github.com/rancher/convoy/releases/download/v0.5.2/convoy.tar.gz
```

در دستور بالا یا توجه به زمان نوشتن این داکیومنت آخرین ورژن است **شما باید با توجه به لینک زیر آخرین نسخه تحت پوشش رو دانلود کنید.**

[https://github.com/rancher/convoy/releases](https://github.com/rancher/convoy/releases)

حالا باید محتویات پوشه Convoy را در `/usr/local/bin` جای گذاری کنید

```bash
cp convoy/convoy convoy/convoy-pdata_tools /usr/local/bin/
```


حالا که محتویات جای گذاری شد باید فایل service آنرا در `/etc/systemd/system/convoy.service` ایجاد کرده و نوشته های زیر را داخلش بگزارید.

```bash
[Unit]
Description=Convoy daemon

[Service]
ExecStart=/usr/local/bin/convoy daemon
Restart=always
RestartSec=5s

[Install]
WantedBy=multi-user.target
```

حالا سرویس را با توجه به دستورات زیر استارت میکنیم. **اگر با ERROR مواجه شدید ادامه دهید**.

توجه داشته باشید که برای دستور اول دو نکته را باید دقت کنید:

1. باید متغیر &lt;vsf_path> را با مسیر جایی که NFS در آن mount شده را جایگذاری کنید.
2. بعد از زدن دستور اول نیاز است که Cntrl+C را بزنید. زیرا تنها این دستور به معنای ایجاد فایل های تنظیماتی است.

```bash

sudo convoy daemon --drivers vfs --driver-opts vfs.path=<vfs_path>
sudo systemctl daemon-reload
sudo systemctl start convoy
sudo systemctl enable convoy

```

حالا برای تنظیم کردن دستی Convoy باید قایل های کافیگ آنرا ایجاد کنیم که هردو در مسیر های زیر هستند. **داخل هر کدام باید با توجه به مسیر های NFS و تنظیمات زیر تنظیم شوند.**

**نکته: باید متغیر &lt;PATH_TO_NFS_VOLUME> را تغییر دهید.**

```bash

cat vfs/vfs.cfg
{"Root":"/var/lib/rancher/convoy/vfs","Path":"<PATH_TO_NFS_VOLUMES>","ConfigPath":"<PATH_TO_NFS_VOLUMES>/config","DefaultVolumeSize":107374182400}

cat convoy.cfg
{"Root":"/var/lib/rancher/convoy","DriverList":["vfs"],"DefaultDriver":"vfs","MountNamespaceFD":"","IgnoreDockerDelete":false,"CreateOnDockerMount":false,"CmdTimeout":""}

```

###### مهم

شما باید Convoy را در تمامی node های docker swarm خود نصب کرده و آنرا در plugin های docker تنظیم کنید

**اگر که Docker نتوانست Convoy را شناسایی کند با استفاده از دستور sudo systemctl restart docker.service آنرا restart کرده**

## تنظیم کردن Convoy در Docker

لطفاً مطمئن شوید که Docker نسخه 1.8+ در دسترس است. سپس مراحل زیر را برای ثبت افزونه Convoy در Docker دنبال کنید

```bash

sudo mkdir -p /etc/docker/plugins/
sudo bash -c 'echo "unix:///var/run/convoy/convoy.sock" > /etc/docker/plugins/convoy.spec'

```

# نحوه استفاده

---


برای اطلاع از تمامی دستورات می توانید به این [سند]("https://github.com/rancher/convoy") مراجعه کنید. اما برخی از دستورات عبارتند از:

```bash

convoy list
convoy create
convoy backup
convoy snapshot

```

* دستور `ls` برای لیست کردن تمامی volume ها توسط Convoy استفاده میشود.
* دستور `Create` برای ساخت Volume ها در Convoy استفاده میشود.
* دستور `Backup` برای گرفتن Backup است.
* دستور `Snapshot` برای گرفتن Snapshot از Volume ها است.

# چگونه در Docker-compose استفاده شود

---

برای استفاده از Convoy در فایل docker-compose می توانید از الگوی زیر استفاده کنید:

```yaml
version: "3.6"
services:
 NAME_OF_SERVICE:
   image: YOUR_DESIRED_IMAGE
   ...
   volumes:
     - CONVOY_VOLUME_1:PATH_TO_CONTAINER_DIRECTORY
     - CONVOY_VOLUME_2:PATH_TO_CONTAINER_DIRECTORY
     - CONVOY_VOLUME_3:PATH_TO_CONTAINER_DIRECTORY
...
volumes:
  CONVOY_VOLUME_1:
    driver: convoy
  CONVOY_VOLUME_2:
   driver: convoy
  CONVOY_VOLUME_3:
    driver: convoy

```

تنها چیزی که باید در نظر بگیرید این است که چگونه Volume های خود را نامگذاری کنید و به Convoy اجازه دهید بقیه نحوه ایجاد Volume ها را مدیریت کند

###### یادداشت مهم:

نامگذاری Volume کمی گیج کننده است زیرا Volume مانند قالب زیر نامگذاری شده اند. StackName_NameOfVolume در اینجا نمونه ای از یکی از پروژه های ما است. app_walletm_pgdata

نکته این است که وقتی از Docker Swarm استفاده می کنیم Stack ای که نام می بریم در ابتدای نام Volume قرار می گیرد

# منابع

---

* [Official Document](https://github.com/rancher/convoy)
*
