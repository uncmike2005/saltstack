#!/bin/bash
#start the salt master and json parser
rpm -Uvh http://ftp.linux.ncsu.edu/pub/epel/6/i386/epel-release-6-8.noarch.rpm
yum -y install salt-master jq
service salt-master start

##stuff to do

##set up aws cli
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
pip install awscli
mkdir ~/.aws
wget -O mycreds -q 'http://169.254.169.254/latest/meta-data/iam/security-credentials/saltProvisioner'
export AWS_SECRET_ACCESS_KEY=`jq -r '.SecretAccessKey' <mycreds`
export AWS_ACCESS_KEY_ID=`jq -r '.AccessKeyId' <mycreds`
export AWS_SESSION_TOKEN=`jq -r '.Token' <mycreds`
export AWS_DEFAULT_REGION='eu-west-1'

##generate key and push to aws
ssh-keygen -q -f /etc/salt/my_salt_cloud_key -t rsa -b 4096 -q -N ""
aws ec2 delete-key-pair --key-name salt_cloud_key
aws ec2 import-key-pair --key-name salt_cloud_key --public-key-material file:///etc/salt/my_salt_cloud_key.pub

##set up security groups
aws ec2 delete-security-group --group-name MySecurityGroupSaltCloudInstances
aws ec2 create-security-group \
    --group-name MySecurityGroupSaltCloudInstances \
    --description "The Security Group applied to all salt-cloud instances"
aws ec2 authorize-security-group-ingress \
    --group-name MySecurityGroupSaltCloudInstances \
    --source-group MySecurityGroupSaltCloudInstances \
    --protocol tcp --port all
aws ec2 authorize-security-group-egress \
    --group-name MySecurityGroupSaltCloudInstances \
    --source-group MySecurityGroupSaltCloudInstances \
    --protocol tcp --port all
aws ec2 authorize-security-group-egress \
    --group-name MySecurityGroupSaltCloudInstances \
    --source-group MySecurityGroupSaltCloudInstances \
    --protocol tcp --port all --cidr 0.0.0.0/0
aws ec2 authorize-security-group-egress \
    --group-name MySecurityGroupSaltCloudInstances \
    --source-group MySecurityGroupSaltCloudInstances \
    --protocol udp --port all --cidr 0.0.0.0/0


##set up cloud.providers and cloud.profile


