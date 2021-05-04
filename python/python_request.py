import json
import requests

def getRequest(domainName):
    PARAMS = {'domain': domainName}
    url="http://127.0.0.1:443/api/v2/getdomain"
    res=requests.get(url, data=PARAMS, verify=False)
  
    if res:
     print('Response OK')
    else:
     print('Response Failed')

    print(res.status_code)
    print(res.headers)
    print(res.text) 
    print(json.loads(res.text))

getRequest("example.com")
