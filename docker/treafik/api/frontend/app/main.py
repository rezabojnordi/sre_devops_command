import requests
import json
import random

from fastapi import FastAPI


app = FastAPI()

instance_id = str(random.randint(0, 1000))

@app.get('/')
# Return all key-value pairs
def main():
    r = requests.get('http://backend')
    data = json.loads(r.content)
    data['frontend_instance'] = instance_id

    return data