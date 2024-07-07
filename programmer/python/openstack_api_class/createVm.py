from authonticate import Authonticate
from createVolume import Volume
from createInstance import Instance
import json
import requests
import time
import threading
import random
#from tqdm import tqdm

imageId=["ID","ID"]
networkId=["ID"]
flavorId=["ID","ID"]
class CreateInstance():
    def __init__(self,instance_number,network_ids,flavor_ids,image_ids):
        self.instance_number=instance_number
        self.network_ids=network_ids
        self.flavor_ids=flavor_ids
        self.image_ids=image_ids
    def create(self):
        self.auth=Authonticate("user","pass")
        print(self.auth.getToken())
        mInstance=[]
        for i in range(self.instance_number):
            mInstance.append(ThreadingSSH(self.flavor_ids, self.network_ids,self.auth,self.image_ids))
        for i in range(800):
            time.sleep(1)
        

class ThreadingSSH(object):
    def __init__(self,flavors,networks,auth,images):
        self.flavors=flavors
        self.networks=networks
        self.auth=auth
        self.images=images
        thread = threading.Thread(target=self.create_instance, args=())
        thread.daemon = True                             # Daemonize thread
        thread.start()

    def create_instance(self):
        flavor=random.choice(self.flavors)
        network=random.choice(self.networks)
        image=random.choice(self.images)
        # volume=Volume(20,self.auth,image_id=image)
        # volume.requestVolume()
        # print("volume Id=============>",volume.volumeHost["volume"]["id"])
        # i=0
        # response=[]
        # while True:
        #     time.sleep(10)
        #     response=volume.getVolumeStatus()
        #     if response[0] == "available":
        #         break
        #     if i>50:
        #         return False
        #     i+=1
 
        instance=Instance("test-instance%s"%str(time.time()),network,flavor,self.auth,image_id=image)
        instance.requestInstance()
        while True:
            time.sleep(10)
            r= instance.getStatus()
            if r[0]=="ACTIVE":
                return r[0]
if __name__ == "__main__":
    instance=CreateInstance(50,networkId,flavorId,imageId)
    instance.create()



        
        


