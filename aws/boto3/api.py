import sys
import boto3
from botocore.exceptions import ClientError
from tabulate import tabulate
ec2 = boto3.client('ec2')
TABLE_HEADER = ['InstanceId', 'InstanceType', 'PrivateIp',
                'PublicIp', 'EbsVolumesTotalSize', 'Status']

if len(sys.argv) < 2:
    print ('Arg #1 as EC2 service name is needed!')
    sys.exit(1)


def get_total_vols_size(vols):
    return sum([vol_obj.size for vol_obj in boto3.resource('ec2').volumes.filter(VolumeIds=[v['Ebs']['VolumeId'] for v in vols])])


def get_instances(instance_id='*'):
    response = ec2.describe_instances()
    instances = response["Reservations"]

    found_any = False
    total_ebs_volumes_size = 0
    result_table = []
    for i in instances:
        for instance in i["Instances"]:
            if instance_id == instance["InstanceId"] or instance_id == '*':
                instance_ebs_volume_size = get_total_vols_size(instance['BlockDeviceMappings'])
                total_ebs_volumes_size += instance_ebs_volume_size
                result_table.append([
                    instance["InstanceId"],
                    instance["InstanceType"],
                    instance["PrivateIpAddress"],
                    instance.get("PublicIpAddress") if instance.get("PublicIpAddress") else '---',
                    instance_ebs_volume_size,
                    instance["State"]["Name"]
                ])
                found_any = True
            if instance_id != '*':
                break
    if found_any:
        result_table.sort(key=lambda x: x[4])
        print (tabulate(result_table, headers=TABLE_HEADER, tablefmt='fancy_grid'))
        print ()
        print ('Total EBS Volume Size:', total_ebs_volumes_size, 'GB')
    else:
        print ('No instance found!')
        sys.exit(2)

get_instances(sys.argv[1])
