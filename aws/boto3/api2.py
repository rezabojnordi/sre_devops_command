import sys
import boto3
from botocore.exceptions import ClientError
from tabulate import tabulate
ec2 = boto3.client('ec2')

def get_total_vols_size(vols):
    total_size = 0
    for vol_obj in boto3.resource('ec2').volumes.filter(VolumeIds=[ v['Ebs']['VolumeId'] for v in vols ]):
        total_size += vol_obj.size
    return total_size

def get_instances(instance_id=None):

    response = ec2.describe_instances()
    instances= response["Reservations"]
    info = []
     
    # if (instance_id !=None):
    info = [['InstanceId', 'InstanceType', 'PrivateIp','PublicIp', 'EbsVolumesTotalSize','Status']]
    for i in instances:
        # print(i["Instances"])
        for instance in i["Instances"]:
            info.append([
                instance["InstanceId"],
                instance["InstanceType"],
                instance["PrivateIpAddress"],
                instance["PublicIpAddress"],
                get_total_vols_size(instance['BlockDeviceMappings']),
                instance["State"]["Name"]
            ])
    
    print(tabulate(info, headers='firstrow', tablefmt='fancy_grid'))



get_instances()
