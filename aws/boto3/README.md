# How to run the script

**Note**: This How-To doc is prepared for Debian-based OSs

## Step 1 - Preparing Python Environment

Install python virtual environment tool and activate it:

```bash
sudo apt-get install python3-venv
python3 -m venv venv
source venv/bin/activate
```

## Step 2 - Install Necessary Python Modules

Install the python mordules listed in `requirements.txt`

```bash
pip install -r requirements.txt
```

## Step 3 - Execute The Script

* Execute script to find a specific instance by passing `Instance ID` as first argument to the script:

```bash
# e.g.:
python3 api.py i-0a30b963fb4427ce1
```

* Execute script to list all instances by passing `*` as first argument to the script:

```bash
python3 api.py '*'
```
