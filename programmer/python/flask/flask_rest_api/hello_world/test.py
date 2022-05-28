import requests

Base = "http://127.0.0.1:5000"

response = requests.get(Base +"/reza")
print(response.json())
print("============================")
# response = requests.post(Base)
print(response.json())

