import requests
import json
class Volume():
    def __init__(self, size,auth, name="",image_id=""):
        self.size=size
        self.zone="nova"
        self.name=name
        self.project_id=auth.authResponse["token"]["project"]["id"]
        self.image_id=image_id
        self.auth=auth

    def getRequestBody(self):
        body={
            "volume": {
            "size": self.size,
            "availability_zone": self.zone,
            "source_volid": None,
            "description": None,
            "multiattach": False,
            "snapshot_id": None,
            "backup_id": None,
            "name": None,
            "imageRef": self.image_id,
            "metadata": {}
            }
        }
        return json.dumps(body)
    def getURL(self):
        return "https://ip:8776/v3/%s/volumes"%(self.project_id)
    def requestVolume(self):
        header= {"X-Auth-Token":self.auth.getToken(),"Content-Type":"application/json"}
        body=self.getRequestBody()
        r = requests.post(self.getURL(), data = body, headers=header,verify=False)
        self.volumeHost=r.json()
    
    def getVolumeStatus(self):
        header= {"X-Auth-Token":self.auth.getToken()}
        r = requests.get(self.getURL()+"/%s"%(self.volumeHost["volume"]["id"]) , headers=header,verify=False)
        response=r.json()
        if "volume" in response:
            return [response["volume"]["status"],response["volume"]["os-vol-host-attr:host"].split("@")[0]]
        else:
            return ["unknown",""]

    def getVolumeBody(self):
        return [self.size,self.zone,self.name,self.project_id]
# class testVolume():
#     def cereatVolumeObject(self):
#         vol=volume(10,project_id="7f0d738b2c634eb49ee83ccbc50a8daf",name="hashem")
#         print(vol.getVolumeBody())
    
#     def requestVolume(self):
#         vol=volume(10,project_id="7f0d738b2c634eb49ee83ccbc50a8daf",name="")
#         vol.requestVolume("gAAAAABfgtv2ExYc17CyNwi9yshgpGyqs7rEyXG_tLbRWQs5kY5HkVdLjPc0dlUwi0RXdKDMU82_36hIJTXNtjWHrNGYFgzpegIK5T9EKZbu7w8ob-1TfccBaYqv41mt_8wLxmJuh7HZO--YgcWDJzT7w9rWWe6zG-iAhhrMSvWlgpgSH3RxISQ")


    
