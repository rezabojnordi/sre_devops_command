from tabulate import tabulate



info = []
info.append(["33dslklkdsds",3333,"jkjnd8j38j38jd38jd",33322,000000,"kik9kim9","mm3m2l2l2l2l","running"])




print(info)
table = [['ImageId', 'InstanceId', 'InstanceType', 'PrivateDnsName','PrivateIpAddress','PublicDnsName','BlockDeviceMappings','State'], 
["33dslklkdsds",3333,"jkjnd8j38j38jd38jd",33322,000000,"kik9kim9","mm3m2l2l2l2l","running"],["33dslklkdsds",3333,"jkjnd8j38j38jd38jd",33322,000000,"kik9kim9","mm3m2l2l2l2l","running"]]
print(tabulate(table, headers='firstrow', tablefmt='fancy_grid'))
