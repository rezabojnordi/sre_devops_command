# Elk config for your project 


MetricBeat - Used for capturing system related metrics like CPU usage, Heap Usage etc
PacketBeat - For monitoring network data
WinlogBeat - For capturing windows event logs
AuditBeat - Monitor user activity and processes
HeartBeat - For uptime monitoing
FunctionBeat - Serverless architectures let you deploy code, without needing to spin up and manage extra underlying software and hardware. Functionbeat brings that same simplicity to monitoring your cloud infrastructure.

Input - It receives data sent by different beats
Filter - Here you need to write parser to parse the data
Output - It pushes data to ElasticSearch Indexes via API call

<img src="1.png" width="800" height="500" />
<img src="2.png" width="800" height="500" />
<img src="3.png" width="800" height="500" />
<img src="4.png" width="800" height="500" />
<img src="5.png" width="800" height="500" />











# terraform_on_aws


## How to start

## step one 
You can install terraform and aws to connect to AWS cloud

### installing Terraform
```
wget https://releases.hashicorp.com/terraform/1.0.7/terraform_1.0.7_linux_amd64.zip
unzip terraform_1.0.7_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform --version

```
### installing AWS Cli
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

```
### How to set Access key ID and Secret access key to connect AWS

You can run this command on your client or server for connectiing AWS Cloud

```
aws configure

```

### Importand command with Terraform

```
terraform init

terraform fmt

terraform validate

terraform plan

terraform plan

terraform apply

terraform destroy
```
### How to change access key and region

```
cat .aws/config
cat .aws/credentials
```
### how to work with aws cli
```
aws ec2 create-key-pair --key-name 'first-keypair-jul-2019' --query 'KeyMaterial' --output text > first-keypair-jul-2019.pem

aws ec2 describe-key-pairs

aws ec2 create-security-group --group-name MySecurityGroup --description "My security group"

aws ec2 describe-vpcs

aws ec2 create-security-group --group-name MySecurityGroup_vpc --description "My security group" --vpc-id vpc-0a95dbde31738083d

aws ec2 describe-security-groups

aws ec2 authorize-security-group-ingress --group-id sg-09d33d937439474db --protocol tcp --port 22 --cidr 0.0.0.0/32
```
### how to create instance with aws cli
```
aws ec2 describe-subnets

aws ec2 run-instances --image-id ami-0d71ea30463e0ff8d --count 1 --instance-type t2.micro --key-name first-keypair-jul-2019 --security-group-ids sg-09d33d937439474db --subnet-id subnet-0d85274255bf8c64e

aws ec2 delete-key-pair --key-name first-keypair-jul-2019

aws ec2 describe-security-groups

aws ec2 delete-security-group --group-id sg-09d33d937439474db

aws ec2 terminate-instances --instance-id i-023f437728b79c

```
