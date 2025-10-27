#Main

vpc_name = "AutomationGurus15"

#Network

public_cidr = "10.0.0.0/17"
public_sub_name = "gurus15-public-subnet"
public_table_name = "gurus15-public-table"
private_1_cidr = "10.0.128.0/18"
private_2_cidr = "10.0.192.0/18"
private_1_sub_name = "gurus15-private-1-subnet"
private_2_sub_name = "gurus15-private-2-subnet"
private_1_table_name = "gurus15-private-1-table"
private_2_table_name = "gurus15-private-2-table"
gateway_name = "gurus15-gateway"
zone_dns = "devops.intuitivesoft.cloud"
site_name = "gurus1515"

#security
security_group_name_bastion = "gurus15-security-group_bastion"
security_group_name_all_egress = "gurus15-security-group_all_egress"
security_group_name_ssh_from_bastion = "gurus15-security-group_ssh_from_bastion"
security_group_name_back = "gurus15-security-group_back"
security_group_name_front = "gurus15-security-group_front"
security_group_name_loadbalancer = "gurus15-security-group_loadbalancer"

#keys

key_name_bastion = "gurus15-keypair-bastion"
key_name_instances = "gurus15-keypair-instances"
key_path = "/home/alexandre/.ssh/"

#bastion

instance_ami_bastion = "ami-084568db4383264d4"
instance_type_bastion = "t2.small"
instance_bastion_name = "gurus15-ec2-bastion"

#front

instance_front_name = "gurus15-ec2-front"
instance_ami_front = "ami-084568db4383264d4"
instance_type_front = "t2.micro"
nombre_instance_front = 1

#back

instance_back_name = "gurus15-ec2-back"
instance_ami_back = "ami-084568db4383264d4"
instance_type_back = "t2.micro"
nombre_instance_back = 1

#loadbalancer

instance_loadbalancer_name = "gurus15-ec2-loadbalancer"
instance_ami_loadbalancer = "ami-084568db4383264d4"
instance_type_loadbalancer = "t2.nano"