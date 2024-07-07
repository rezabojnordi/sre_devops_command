from fastapi import FastAPI
from fastapi.responses import JSONResponse

app = FastAPI()

store = {
    'demo': 'this is important data!'
}

@app.get('/')
# Return all key-value pairs
def read_keys():
    return store

@app.post('/')
# Create a new key-value pair
def create_key(key: str, value: str):
    store[key] = value
    return {key: store[key]}
