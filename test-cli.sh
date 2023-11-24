#!/bin/bash

# Variables
vpc_name="VPC-MotiJuan"
region="us-east-1"
cidr_block="192.168.0.0/22"

# Crear VPC
vpc_id=$(aws ec2 create-vpc --cidr-block $cidr_block --query 'Vpc.VpcId' --output text --region $region)
aws ec2 create-tags --resources $vpc_id --tags Key=Name,Value=$vpc_name --region $region
aws ec2 modify-vpc-attribute --vpc-id $vpc_id --enable-dns-support "{\"Value\":true}" --region $region
aws ec2 modify-vpc-attribute --vpc-id $vpc_id --enable-dns-hostnames "{\"Value\":true}" --region $region
echo "VPC creada con ID: $vpc_id"

aws ec2 wait vpc-available --vpc-ids $vpc_id

# Desarrollo

name="desarrollo"

subnet_cidr="192.168.0.0/23"
subnet_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block $subnet_cidr --availability-zone $availability_zone --query 'Subnet.SubnetId' --output text --region $region)
instance_name="ec2-$name"
aws ec2 run-instances --image-id ami-0230bd60aa48260c6 --instance-type t2.micro --subnet-id $subnet_id --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=ec2-desarrollo}]" --region $region

echo "Subred y EC2 para $name creadas"

# Soporte

name="soporte"
subnet_cidr="192.168.2.0/24"
subnet_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block $subnet_cidr --availability-zone $availability_zone --query 'Subnet.SubnetId' --output text --region $region)
instance_name="ec2-$name"
aws ec2 run-instances --image-id ami-0230bd60aa48260c6 --instance-type t2.micro --subnet-id $subnet_id --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=ec2-soporte}]" --region $region

echo "Subred y EC2 para $name creadas"

# Ingeniería
availability_zone="us-east-1a"
name="ingenieria"
subnet_cidr="192.168.3.0/25"
subnet_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block $subnet_cidr --availability-zone $availability_zone --query 'Subnet.SubnetId' --output text --region $region)
instance_name="ec2-$name"
aws ec2 run-instances --image-id ami-0230bd60aa48260c6 --instance-type t2.micro --subnet-id $subnet_id --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=ec2-ingenieria}]" --region $region

echo "Subred y EC2 para $name creadas"

# Mantenimiento

name="mantenimiento"
subnet_cidr="192.168.3.128/27"
subnet_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block $subnet_cidr --availability-zone $availability_zone --query 'Subnet.SubnetId' --output text --region $region)
instance_name="ec2-$name"
aws ec2 run-instances --image-id ami-0230bd60aa48260c6 --instance-type t2.micro --subnet-id $subnet_id --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=ec2-mantenimiento}]" --region $region

echo "Subred y EC2 para $name creadas"

echo "Script completado"
