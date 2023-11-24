#!/bin/bash
# Variables
region="us-east-1" # Cambia esto a la región de tu preferencia
vpc_cidr_block="192.168.0.0/22"

# Crear VPC
vpc_id=$(aws ec2 create-vpc --cidr-block $vpc_cidr_block --query 'Vpc.VpcId' --output text)

# Configurar VPC para DNS hostnames y DNS support
aws ec2 modify-vpc-attribute --vpc-id $vpc_id --enable-dns-support "{\"Value\":true}"
aws ec2 modify-vpc-attribute --vpc-id $vpc_id --enable-dns-hostnames "{\"Value\":true}"

# Crear subredes
function crear_subredes {
  nombre_departamento=$1
  cidr_block=$2
  subnet_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block $cidr_block --query 'Subnet.SubnetId' --output text)

  # Crear una instancia EC2 en la subred
  instance_id=$(aws ec2 run-instances \
    --image-id ami-050406429a71aaa64 \
    --instance-type t2.micro \
    --subnet-id $subnet_id \
    --query 'Instances.InstanceId' \
    --output text)

  # Asignar nombre a la instancia
  aws ec2 create-tags --resources $instance_id --tags Key=Name,Value=ec2-$nombre_departamento
  echo "Creado: Subred $nombre_departamento ($cidr_block), Instancia EC2: ec2-$nombre_departamento"
}

# Crear subredes para cada departamento
crear_subredes "desarrollo" "192.168.0.0/23"
crear_subredes "soporte" "192.168.2.0/24"
crear_subredes "ingenieria" "192.168.3.0/25"
crear_subredes "mantenimiento" "192.168.3.128/27"
