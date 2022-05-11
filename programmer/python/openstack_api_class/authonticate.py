import requests
import json
import time

class Authonticate():
    def __init__(self, user_name, password, project_scope_name="admin",domain_id="default"):
        self.user_name=user_name
        self.password=password
        self.project_scope_name=project_scope_name
        self.expire_time=None
        self.domain_id=domain_id
        self.token=None
    def getRequestBody(self):
        body={
            "auth": {
                "identity": {
                    "methods": ["password"],
                    "password": {
                        "user": {
                            "name": self.user_name,
                            "domain": { "id": "default" },
                            "password": self.password
                        }   
                    }
                },
                "scope": {
                    "project": {
                    "name": self.project_scope_name,
                    "domain": { "id": self.domain_id }
                    }
                }
            }
        }
        return json.dumps(body)

    def getURL(self):
        return "https://ip:port/v3/auth/tokens"

    def getToken(self):
        if self.expire_time==None or self.expire_time < time.time():
            body=self.getRequestBody()
            header= {"Content-Type":"application/json"}
            r = requests.post(self.getURL(),headers=header, data = body,verify=False)
            self.authResponse=r.json()
            if r.status_code ==201: 
                self.token=r.headers["X-Subject-Token"]
            else:
                self.status="failed"
                self.token=None
            self.expire_time=time.time()+1200
        return self.token


class TestAuthonticate():
    def testGetBody(self):
        auth=Authonticate("user","pass")
        print(auth.getRequestBody())
    
    def testGetToken(self):
        auth=Authonticate("user","pass")
        return auth.getToken()




    
