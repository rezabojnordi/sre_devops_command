import os
class appilication():
    def __init__(self,link=[],name="",live="on",record="off",option="create"):
        self.name=name
        self.live=live
        self.record=record
        self.push=link
        self.filePath(name)
        if option=="add":
            if self.fileExist:
                for i in link:
                    self.push.append(i)
        if option=="delete":
            pass

    def readConfig(self):
        f=open(self.filePath,"r")
        content=f.read().splitlines()
        f.close()
        for line in content:
            if "application" in line:
                self.name=line.split(" ")[1][:-1]
            if "live" in line:
                self.live=line.split(" ")[1][:-1]
            if "record" in line:
                self.record=line.split(" ")[1][:-1]
            if "push" in line:
                self.push.append(line.split(" ")[1][:-1])

    def filePath(self,name):
        self.filePath="%s"%(self.name)
        if os.path.exists(self.filePath):
            self.readConfig()
            self.fileExist=True
        else:
            self.fileExist=False
    def createFile(self):
        f=open(self.filePath,"+w")
        f.write("application %s {\n"%self.name)
        f.write("live %s;\n"%self.live)
        f.write("record %s;\n"%self.record)
        for line in self.push:
            f.write("push %s;\n"%line)
        f.write("}\n")
        f.close()
