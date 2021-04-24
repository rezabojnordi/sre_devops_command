import dns.resolver

def check_nameserver(domain):
    try:
        nameserver=["8.8.8.8", "1.1.1.1", "9.9.9.9"]
        nameServers =[{'name_server': 'cdn1.example.com', 'ip': '251.251.251.251'}, {'name_server': 'cdn1.example.com', 'ip': '251.251.251.251'}]
        flag=True
        resolver=dns.resolver.Resolver()
        for i in range(3):
            if flag:
                flag=False
                for name in nameserver:
                    try:
                        resolver.nameservers =[name]
                        answers=resolver.query(domain,'NS')
                        names=[str(data)[:-1].lower() for data in answers]
                    except:
                        names=[]
                    if len([ '1' for name in names if name in [server['name_server'] for server in nameServers]])!=len(nameServers) or len(nameServers)!=len(names):
                        flag=True
       
        return not flag 
    except Exception as e:
        return False
    return False
    
check_nameserver("prodevop.ir")  
