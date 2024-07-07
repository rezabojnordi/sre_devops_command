import requests
import json
import time

class Instance():
    def __init__(self, name ,network_id,flavor_id,auth, host=None,image_id="" ,key_name="admin",source_type="volume",user_data=None ):
        self.instance_name=name
        self.image_id=image_id
        self.flavor_id=flavor_id
        self.network_id=network_id
        self.source_type=source_type
        self.key_name=key_name
        self.host=host
        self.user_data=user_data
        self.auth=auth

    def getRequestBody(self):
        
        body={
                "server": {
                    "name": self.instance_name,
                    "flavorRef": self.flavor_id,
                    "networks": [
                        {
                            "uuid": self.network_id
                        }
                    ],
                    "user_data":"I2Nsb3VkLWNvbmZpZwpwYXNzd29yZDogMTIzNDU2CmNocGFzc3dkOiB7IGV4cGlyZTogRmFsc2UgfQpzc2hfcHdhdXRoOiBUcnVlCnBhY2thZ2VzOgogIC0gYXBhY2hlMgogIC0gcWVtdS1ndWVzdC1hZ2VudA==",
                    "imageRef":self.image_id
  
                    }
                    # "key_name": self.key_name,
                    # "host": self.host
                }
            
    
        # if self.user_data!=None:
        #     body["server"]["user_data"]==self.user_data

        return json.dumps(body)

    def getURL(self):
        return "https://ip:port/v2.1/servers"

    def requestInstance(self):
        header= {"X-Auth-Token":self.auth.getToken(), "X-OpenStack-Nova-API-Version": "2.74","Content-Type":"application/json"}
        body=self.getRequestBody()
        r = requests.post(self.getURL(), data = body, headers=header,verify=False)
        self.instance_details=r.json()
        print("json*****************************************",self.instance_details)
        return self.instance_details

    def getStatus(self):
        header= {"X-Auth-Token":self.auth.getToken()}
        r = requests.get(self.getURL()+"/%s"%self.instance_details["server"]["id"] , headers=header,verify=False)
        response=r.json()
        if "server" in response and "addresses" in response["server"] and "public" in response["server"]["addresses"]:
            return [response["server"]["status"],response["server"]["addresses"]["public"][0]["addr"]]
        return ["unknown",""]
