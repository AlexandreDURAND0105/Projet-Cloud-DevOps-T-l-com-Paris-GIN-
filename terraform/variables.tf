#Main
variable "vpc_name" {
  type = string
}

#Network
variable "public_sub_name" {
  type = string
}
variable "public_cidr" {
  type = string
}
variable "private_1_sub_name" {
  type = string
}
variable "private_1_cidr" {
  type = string
}
variable "private_2_sub_name" {
  type = string
}
variable "private_2_cidr" {
  type = string
}
variable "gateway_name" {
  type = string
}
variable "public_table_name" {
  type = string
}
variable "private_1_table_name" {
  type = string
}
variable "private_2_table_name" {
  type = string
}
variable "zone_dns" {
  type = string
}
variable "site_name" {
  type = string
}

#security
variable "security_group_name_bastion" {
  type = string
}
variable "security_group_name_back" {
  type = string
}
variable "security_group_name_front" {
  type = string
}
variable "security_group_name_all_egress" {
  type = string
}
variable "security_group_name_ssh_from_bastion" {
  type = string
}
variable "security_group_name_loadbalancer" {
  type = string
}



#keys
variable "key_name_bastion" {
  type = string
}
variable "key_name_instances" {
  type = string
}
variable "key_path" {
  type = string
}

#bastion
variable "instance_type_bastion" {
  type = string
}
variable "instance_ami_bastion" {
  type = string
}
variable "instance_bastion_name" {
  type = string
}

#back
variable "instance_ami_back" {
  type = string
}
variable "instance_type_back" {
  type = string
}
variable "instance_back_name" {
  type = string
}
variable "nombre_instance_back" {
  type = number
}

#front
variable "instance_ami_front" {
  type = string
}
variable "instance_type_front" {
  type = string
}
variable "instance_front_name" {
  type = string
}
variable "nombre_instance_front" {
  type = number
}

#loadbalancer
variable "instance_ami_loadbalancer" {
  type = string
}
variable "instance_type_loadbalancer" {
  type = string
}
variable "instance_loadbalancer_name" {
  type = string
}


